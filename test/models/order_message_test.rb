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
  
  test "valid? - no from email" do
    message = OrderMessage.new(@approved,'resubmitted',users(:no_email).id)
    assert_not(message.valid?)
    assert(message.notice.start_with? 'No email address for Homer')
  end
  
  test "valid? - no to" do
    message = OrderMessage.new(@approved,'changed',@brian.id)
    assert_not(message.valid?,'Invalid message')
    assert(message.notice.start_with?('Missing user records'),'Missing user records')
  end
  
end