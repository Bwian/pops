require 'test_helper'

class OrderFilterTest < ActiveSupport::TestCase

  setup do
    @order_filter = OrderFilter.new({
      role: 'Creator',
      draft: "1",
      submitted: "1",
      approved: "0",
      processed: "0"
    })
  end
  
  test "accessors" do
    assert_equal('Creator', @order_filter.role)
    assert_equal('1', @order_filter.draft)
    assert_equal('1', @order_filter.submitted)
    assert_equal('0', @order_filter.approved)
    assert_equal('0', @order_filter.processed)
  end
  
  test "empty params" do
    order_filter = OrderFilter.new(nil)
    assert_nil(order_filter.role)
  end
  
end
