require 'test_helper'

class OrderFilterTest < ActiveSupport::TestCase

  setup do
    @order_filter = OrderFilter.new(users(:brian).id)
  end
  
  test "accessors" do
    assert_equal(OrderStatus::PROCESSOR, @order_filter.role)
    assert_equal('0', @order_filter.draft)
    assert_equal('0', @order_filter.submitted)
    assert_equal('1', @order_filter.approved)
    assert_equal('0', @order_filter.processed)
  end
  
  test "booleans" do
    assert_not(@order_filter.draft?, 'Draft')
    assert_not(@order_filter.submitted?, 'Submitted')
    assert(@order_filter.approved?, 'Approved')
    assert_not(@order_filter.processed?, 'Processed')
  end
  
  test "nil booleans" do
    @order_filter.draft = nil
    assert_not(@order_filter.draft?, 'Draft')
    @order_filter.submitted = nil
    assert_not(@order_filter.submitted?, 'Submitted')
    @order_filter.approved = nil
    assert_not(@order_filter.approved?, 'Approved')
    @order_filter.processed = nil
    assert_not(@order_filter.processed?, 'Processed')
  end
  
  test "update new role" do
    @order_filter.update({role: OrderStatus::CREATOR})
    assert_equal('1', @order_filter.draft)
    assert_equal('1', @order_filter.submitted)
    assert_equal('0', @order_filter.approved)
    assert_equal('0', @order_filter.processed)
  end
  
  test "update same role" do
    @order_filter.update({
      role: OrderStatus::PROCESSOR, 
      draft: '0',
      submitted: '0',
      approved: '0',
      processed: '1' 
    })
    assert_equal('0', @order_filter.draft)
    assert_equal('0', @order_filter.submitted)
    assert_equal('0', @order_filter.approved)
    assert_equal('1', @order_filter.processed)
  end
end
