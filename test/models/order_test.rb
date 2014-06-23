require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @draft     = orders(:draft)
    @submitted = orders(:submitted)
    @approved  = orders(:approved)
    @brian     = users(:brian)
  end
  
  test 'supplier relationship' do
    assert_equal('MISC PURCHASES',@draft.supplier.name)
  end
  
  test 'status_name valid' do
    assert_equal('Draft',@draft.status_name)
  end 
  
  test 'status_name invalid' do
    assert_equal('Invalid status - nil', orders(:invalid).status_name)
  end
  
  test 'atby' do
    assert_equal(1,@draft.atby.size)
    assert_equal('created on 11/11/2013 at 08:15 by brian', @draft.atby[0])
  end 
  
  test 'supplier_desc' do
    assert_equal("Joe's Miscellaneous Oddments", @draft.supplier_desc)
    assert_equal("COLES ONLINE", orders(:invalid).supplier_desc)
  end
  
  test 'supplier_address' do
    assert_equal('927 Sturt St',@submitted.supplier_address1,'address1')
    assert_equal('Ballarat',@submitted.supplier_address2,'address2')
    assert_equal('Victoria',@submitted.supplier_address3,'address3')
  end
  
  test 'supplier_address_misc' do
    assert_equal('',@draft.supplier_address1,'address1')
    assert_equal('',@draft.supplier_address2,'address2')
    assert_equal('',@draft.supplier_address3,'address3')
  end
  
  test 'subtotal' do
    assert_in_delta(14.49,@draft.subtotal,0.001)
  end
  
  test 'gst' do
    assert_in_delta(0.45,@draft.gst,0.001)
  end
  
  test 'grandtotal' do
    assert_in_delta(14.94,@draft.grandtotal,0.001)
  end
  
  test 'formatted_subtotal' do
    assert_equal('14.49',@draft.formatted_subtotal)
  end
  
  test 'formatted_gst' do
    assert_equal('0.45',@draft.formatted_gst)
  end
  
  test 'formatted_grandtotal' do
    assert_equal('14.94',@draft.formatted_grandtotal)
  end
  
  test 'to_draft' do
    @submitted.to_draft
    assert_equal(OrderStatus::DRAFT,@submitted.status)
  end
  
  test 'to_submitted' do
    @draft.to_submitted
    assert_equal(OrderStatus::SUBMITTED,@draft.status)
  end
  
  test 'to_approved' do
    @submitted.to_approved(@brian.id)
    assert_equal(OrderStatus::APPROVED,@submitted.status)
  end
  
  test 'to_processed' do
    @approved.to_processed(@brian.id)
    assert_equal(OrderStatus::PROCESSED,@approved.status)
  end
  
  test 'draft?' do
    assert(@draft.draft?)
    assert_not(@approved.draft?)
  end
  
  test 'submitted?' do
    assert(@submitted.submitted?)
    assert_not(@draft.submitted?)
  end
  
  test 'approved?' do
    assert(@approved.approved?)
    assert_not(@draft.approved?)
  end
  
  test 'processed?' do
    @processed = @approved
    @processed.status = OrderStatus::PROCESSED
    assert(@processed.processed?)
    assert_not(@draft.processed?)
  end
  
  test 'approver_present' do
    @submitted.approver_id = nil
    assert !@submitted.save, "Saved the order without an approver"
  end
  
  test 'approver_not_processor' do
    @approved.to_processed(@brian.id)
    @approved.processor_id = @approved.approver_id
    assert !@approved.save, "Saved the order with processor the same as the approver"
  end
  
  test 'dirty and send' do
    # example of testing for changed models and attributes
    assert_not(@draft.changed?)
    @draft.to_submitted
    assert(@draft.changed?)
    assert(@draft.status_changed?)
    assert('D',@draft.status_was)
    assert_not(@draft.supplier_id_changed?)
    
    # example of the use of "send"
    assert(@draft.send("status_changed?"))
    assert_not(@draft.send("supplier_id_changed?"))
    assert_equal('MISC PURCHASES',@draft.send("supplier").send("name"))
  end
  
  test 'to_json' do
    oj = @draft.to_json
    ojs = oj.to_json
    ojsh = ActiveSupport::JSON.decode(ojs)
    assert(oj['id'] == ojsh['id'],'id')
    assert(oj['created_at'] == ojsh['created_at'],'created_at')
    assert_equal('brian',ojsh['approver'],'approver')
    assert_equal('Draft',ojsh['status'],'status')
  end
  
  test 'sendmail - approved' do
    @submitted.to_approved(@brian.id)
    message = @submitted.sendmail(@brian.id)
    assert(message,'Message is nil')
    assert(message.valid?,'Message is invalid')
    assert_equal("Order emailed to Sean Anderson at sean@somewhere.com",message.notice)
  end
  
  test 'add_notes?' do
    assert_not(@draft.add_notes?,'Draft')
    assert(@submitted .add_notes?,'Submitted')
    assert_not(Order.new.add_notes?,'New')
  end
  
  test 'set_payment_date - nil' do
    @approved.set_payment_date
    assert_nil(@submitted.payment_date)
  end
  
  test 'set_payment_date - simple' do
    @submitted.set_payment_date
    assert_equal(Date.new(2013,12,8),@submitted.payment_date)
  end
  
  test 'set_payment_date - complex' do
    @submitted.supplier.payment_term = payment_terms(:three)
    @submitted.set_payment_date
    assert_equal(Date.new(2014,1,10),@submitted.payment_date)
  end
  
end
