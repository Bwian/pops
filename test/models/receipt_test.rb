require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  setup do
    @new = Receipt.new
    @item1 = items(:one)
    @item2 = items(:two)
    @user = users(:brian)
  end
  
  test 'item count' do
    assert_equal(0,@item1.receipts.size)
    assert_equal(2,@item2.receipts.size)
  end
  
  test 'save' do
    new_receipt
    assert(@new.save)
    assert_equal('A',@new.status)
  end 

  test 'over price' do
    new_receipt
    @new.price = 5.00
    assert_not(@new.save)
    assert(@new.errors.messages[:price])
  end
  
  test 'formatted_date' do  
    assert(receipts(:one).formatted_date =~ /\d{2}\/\d{2}\/\d{4} - \d{2}:\d{2}/)
  end
  
  private
  
  def new_receipt
    @new.item = @item1
    @new.price = 1.00
    @new.receiver = @user
  end
  
end
