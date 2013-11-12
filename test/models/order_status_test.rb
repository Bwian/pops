require 'test_helper'

class OrderStatusTest < ActiveSupport::TestCase
  
  test 'draft' do
    assert_equal('D', OrderStatus::DRAFT)
  end
  
  test 'submitted' do
    assert_equal('S', OrderStatus::SUBMITTED)
  end
  
  test 'approved' do
    assert_equal('A', OrderStatus::APPROVED)
  end
  
  test 'processed' do
    assert_equal('P', OrderStatus::PROCESSED)
  end
  
  test 'invalid' do
    assert_equal('Invalid status - nil', OrderStatus.status(nil))
    assert_equal('Invalid status - X', OrderStatus.status('X'))
  end
  
  test 'status' do
    assert_equal('Draft', OrderStatus.status('D'))
  end
  
end
