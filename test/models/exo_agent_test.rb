require 'test_helper'

class ExoAgentTest < ActionView::TestCase
  TABLE = 'Program'
  
  setup do
    @agent = ExoAgent.new
  end
  
  test "build_select programs" do
    sql = @agent.send('build_select',Program)
    assert(sql.include? '[BRANCHES]')
    assert(sql.include? 'BRANCHNO,')
  end
  
  test "connection should fail" do 
    assert_not(@agent.extract(Program))
    assert(@agent.notice.start_with? "Could not create connection to SQL Server database")
  end
  
  test "invalid configuration" do
    @agent.host = nil
    assert_not(@agent.extract(Program))
    assert(@agent.notice =~ /.* invalid - missing host/)
  end

end