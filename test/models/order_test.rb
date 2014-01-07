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
  
  test 'subtotal' do
    assert_in_delta(14.49,@draft.subtotal,0.001)
  end
  
  test 'gst' do
    assert_in_delta(0.45,@draft.gst,0.001)
  end
  
  test 'grandtotal' do
    assert_in_delta(14.94,@draft.grandtotal,0.001)
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
  
  test 'dirty and send' do
    assert_not(@draft.changed?)
    @draft.to_submitted
    assert(@draft.changed?)
    assert(@draft.status_changed?)
    assert_not(@draft.supplier_id_changed?)
    assert(@draft.send("status_changed?"))
    assert_not(@draft.send("supplier_id_changed?"))
    assert_equal('MISC PURCHASES',@draft.send("supplier").send("name"))
  end
end
