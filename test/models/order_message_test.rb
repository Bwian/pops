require 'test_helper'

class OrderMessageTest < ActiveSupport::TestCase
  
  test "approved" do
    message = OrderMessage.new(orders(:approved),'approved')
    assert_equal('Order emailed to Sean Anderson at sean@somewhere.com',message.notice)
  end
  
end