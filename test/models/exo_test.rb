require 'test_helper'

class ExoTest < ActionView::TestCase
  
  attr_reader :status
    
  include Exo
  
  test "formatted_status valid" do
    test_status('Active',ACTIVE)
    test_status('Deleted',DELETED)
    test_status('New',NEW)
  end
  
  test "formatted_status invalid" do
    test_status('Invalid status - X', 'X')
    test_status('Invalid status - nil', nil)
  end
  
  test "attribute_list" do
    assert_equal(1,Account.new.attribute_list.size,'Program')
  end
  
  private
  
  def test_status(expected,status)
    @status = status
    assert_equal(expected,formatted_status)
  end
  
end