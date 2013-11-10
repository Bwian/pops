require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = orders(:one)
  end
  
  test 'supplier relationship' do
    assert_equal('MISC PURCHASES',@order.supplier.name)
  end
end
