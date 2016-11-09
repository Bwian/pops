require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @new = Item.new
    @draft = orders(:draft)
    @item1 = items(:one)
    @item2 = items(:two)
    @item4 = items(:four)
  end
  
  test 'item count' do
    assert_equal(2,@draft.items.size)
  end
  
  test 'any?' do
    assert(@draft.items.any?)
    assert_not(orders(:invalid).items.any?)
  end
  
  test 'gst' do
    assert_in_delta(0.45,@item1.gst,0.001)
    assert_in_delta(0.00,@item2.gst,0.001)
  end
  
  test 'subtotal' do
    assert_in_delta(4.50,@item1.subtotal,0.001)
    assert_in_delta(9.99,@item2.subtotal,0.001)
  end
  
  test 'formatted_gst' do
    assert_equal('0.45',@item1.formatted_gst)
  end
  
  test 'formatted_subtotal' do
    assert_equal('',@new.formatted_subtotal)
    assert_equal('4.50',@item1.formatted_subtotal)
  end
  
  test 'formatted_price' do
    assert_equal('',@new.formatted_price)
    assert_equal('4.95',@item1.formatted_price)
  end
  
  test 'program_name found' do
    assert(@item1.program_name.start_with? 'Program One')
  end
  
  test 'program_name not found' do
    @item1.program_id = 99
    assert_equal('Missing Program 99',@item1.program_name)
  end
  
  test 'program_code' do
    assert_equal('5',@item4.program_code)
  end
  
  test 'account_name found' do
    assert(@item1.account_name.start_with? 'Account One')
  end
  
  test 'account_name not found' do
    @item1.account_id = 99
    assert_equal('Missing Account 99',@item1.account_name)
  end
  
  test 'tax_rate_name found' do
    assert_equal('Normal GST',@item1.tax_rate_name)
  end
  
  test 'tax_rate_name not found' do
    @item1.tax_rate_id = 99
    assert_equal('Missing Tax Rate 99',@item1.tax_rate_name)
  end
  
  test 'tax_rate_short_name found' do
    assert_equal('GST',@item1.tax_rate_short_name)
  end
  
  test 'tax_rate_short_name not found' do
    @item1.tax_rate_id = 99
    assert_equal('Missing Tax Rate 99',@item1.tax_rate_short_name)
  end
  
  test 'receipt_total' do
    assert_in_delta(3.95,@item2.receipt_total,0.001)
  end
  
  test 'formatted_receipt_total' do
    assert_equal('3.95',@item2.formatted_receipt_total)
  end
  
  test 'to_json' do
    ij = @item1.to_json
    ijs = ij.to_json
    ijsh = ActiveSupport::JSON.decode(ijs)
    assert(ij.eql?ijsh)
  end
  
  test 'optimistic locking' do
    i1 = Item.find(@item1.id)
    i2 = Item.find(@item1.id)
    i1.description = 'changed i1'
    i1.save
    i2.description = 'changed i2'
    assert_not(i2.save)
    assert(i2.errors.messages[:locking_error])
  end
end
