require 'test_helper'

class OrderStatusTest < ActiveSupport::TestCase
  
  test 'draft' do
    assert_equal('Draft',OrderStatus.draft)
  end
  
  test 'submitted' do
    assert_equal('Submitted',OrderStatus.submitted)
  end
  
  test 'approved' do
    assert_equal('Approved',OrderStatus.approved)
  end
  
  test 'processed' do
    assert_equal('Processed',OrderStatus.processed)
  end
  
  test 'invalid' do
    assert_equal('Invalid status - nil',OrderStatus.status(nil))
    assert_equal('Invalid status - X',OrderStatus.status('X'))
  end
  
end
