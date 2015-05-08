require 'test_helper'

class ParseLogTest < ActiveSupport::TestCase

  LINE = "I, [2015-04-16T19:14:16.948818 #11825]  INFO -- : Building Unassigned group"

  setup do
    @pl = ParseLog.new('./test/data/tbr.log')
  end
  
  test "parse" do
    a = @pl.send('parse',LINE)
    assert_equal('info',a[:type])
    assert_equal('Thursday Apr 16 - 19:14:16',a[:time].strftime("%A %b %-d - %H:%M:%S"))
    assert(a[:desc].start_with?('Building'))
  end

  test "session" do
    assert_equal(15,@pl.session(1).count)
    assert_equal(10,@pl.session(3).count)
    assert_equal(0,@pl.session(6).count)
  end
  
  test "sessions" do
    assert_equal(5,@pl.sessions.count)
    assert_equal("Friday May 8 - 10:42:58",@pl.sessions[3])
  end
  
  test "selection" do
    binding.pry
    assert_equal(5,@pl.selection.count)
  end
    
end
