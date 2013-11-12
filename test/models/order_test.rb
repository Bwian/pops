require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @draft = orders(:draft)
  end
  
  test 'supplier relationship' do
    assert_equal('MISC PURCHASES',@draft.supplier.name)
  end
  
  test 'status_name valid' do
    assert_equal('Draft',@draft.status_name)
  end 
  
  test 'status_name invalid' do
    assert_equal('Invalid status - nil',orders(:invalid).status_name)
  end 
end
