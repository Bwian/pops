require 'test_helper'

class LdapAgentTest < ActionView::TestCase
  
  setup do
    @agent = LdapAgent.new
  end
  
  test "configuration attributes" do
    assert_equal('invalid',@agent.instance_eval('@host'))
    assert_equal(388,@agent.instance_eval('@port'))
    assert_equal('query',@agent.instance_eval('@user'))
    assert_equal('password',@agent.instance_eval('@password'))
  end
  
  test "default configuration attributes" do
    ENV['ldap_port'] = nil
    @agent = LdapAgent.new
    assert_equal(389,@agent.instance_eval('@port'))
  end
  
  test "connection should fail" do 
    assert_not @agent.authenticate('user','password')
    assert(@agent.notice.start_with? "Could not create connection to LDAP Server")
  end
  
  test "invalid configuration" do
    ENV['ldap_host'] = nil
    @agent = LdapAgent.new
    assert_not @agent.authenticate('user','password')
    assert(@agent.notice =~ /.* invalid - missing host/)
  end

end