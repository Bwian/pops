require 'test_helper'

class ExoAgentTest < ActionView::TestCase
  TABLE = 'Program'
  
  setup do
    @agent = ExoAgent.new
  end
  
  test "configuration attributes" do
    assert_equal('invalid',@agent.instance_eval('@host'))
    assert_equal(1432,@agent.instance_eval('@port'))
    assert_equal('EXO_UCB_TEST',@agent.instance_eval('@database'))
    assert_equal(2,@agent.instance_eval('@login_timeout'))
    assert_equal('username',@agent.instance_eval('@user'))
    assert_equal('password',@agent.instance_eval('@password'))
  end
  
  test "default configuration attributes" do
    ENV['sql_server_port'] = nil
    ENV['sql_server_timeout'] = nil
    @agent = ExoAgent.new
    assert_equal(1433,@agent.instance_eval('@port'))
    assert_equal(1,@agent.instance_eval('@login_timeout')) 
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
    ENV['sql_server_host'] = nil
    @agent = ExoAgent.new
    assert_not(@agent.extract(Program))
    assert(@agent.notice =~ /.* invalid - missing host/)
  end

end