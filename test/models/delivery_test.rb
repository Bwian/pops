require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(2, Delivery.selection.count)
    
    delivery = Delivery.new
    delivery.name = 'New'
    delivery.address = 'New address'
    delivery.save
    
    assert_equal(3, Delivery.selection.count)
  end
end
