require 'test_helper'

class ParseLogTest < ActiveSupport::TestCase

  LINE = "I, [2015-04-16T19:14:16.948818 #11825]  INFO -- : Building Unassigned group"

  setup do
    @pl = ParseLog.new('./test/data/tbr.log')
  end
  
  test "parse" do
    a = @pl.send('parse',LINE)
    assert_equal('info',a[0])
    assert_equal('Thursday Apr 16',a[1])
    assert_equal('19:14:16',a[2])
    assert(a[3].start_with?('Building'))
  end
end
