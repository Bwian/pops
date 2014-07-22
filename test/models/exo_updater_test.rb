require 'test_helper'

class ExoUpdateerTest < ActionView::TestCase
  
  test "zero programs" do
    eu = ExoUpdater.new(Program,[])
    assert(eu.notice.starts_with?('No'))
  end
  
  test "all existing programs" do
    eu = ExoUpdater.new(Program,[{id: 5},{id: 6}])
    assert(eu.notice.starts_with?('2'))
    assert(eu.notice.include?('No new'))
    assert_equal(6,Program.count)
  end
  
  test "program record added" do
    eu = ExoUpdater.new(Program,[{id: 5},{id: 7, name: 'Program Name'}])
    assert(eu.notice.starts_with?('2'))
    assert(eu.notice.include?('1 new'))
    assert(eu.notice.include?('1 found'))
    assert_equal(7,Program.count)
    p = Program.find(7)
    assert_equal('Program Name',p.name)
  end

end