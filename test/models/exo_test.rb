require 'test_helper'

class ExoTest < ActionView::TestCase
  
  include Exo
  
  test "status_desc valid" do
    assert_equal('Active',Exo::status_desc('A'))
    assert_equal('Deleted',Exo::status_desc('D'))
    assert_equal('New',Exo::status_desc('N'))
  end
  
  test "status_desc invalid" do
    assert_equal('Invalid status - X', Exo::status_desc('X'))
    assert_equal('Invalid status - nil', Exo::status_desc(nil))
  end
end