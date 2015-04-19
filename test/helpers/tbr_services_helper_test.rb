require 'test_helper'

class TbrServicesHelperTest < ActionView::TestCase
  test "format_phone_number" do
    assert_equal('04&nbsp;1850&nbsp;5555',format_phone_number('0418505555'))
    assert_equal('N1234',format_phone_number('N1234'))
  end
end
