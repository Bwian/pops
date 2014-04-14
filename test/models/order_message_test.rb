require 'test_helper'

class OrderMessageTest < ActiveSupport::TestCase
  
  setup do
    @approved = orders(:approved)
    @brian = users(:brian)
  end
  
  test "approved" do
    message = OrderMessage.new(@approved,'approved',@brian.id)
    assert_equal('Order emailed to Sean Anderson at sean@somewhere.com',message.notice)
  end
  
  test "resubmitted" do
    message = OrderMessage.new(@approved,'resubmitted',@brian.id)
    assert_equal('Order emailed to Brian Collins at brian.pyrrho@bigpond.com',message.notice)
  end
  
end