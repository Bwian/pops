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
  
  test 'atby' do
    assert_equal('created on 11/11/2013 at 08:15 by brian', @draft.atby)
  end 
end
