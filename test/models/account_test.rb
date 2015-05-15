require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "selection and reset" do
    Rails.cache.delete(Account::CACHE_KEY)
    assert_equal(5, Account.selection.count)
    
    account = Account.new
    account.name = 'New Account'
    account.status = 'N'
    account.save
    
    assert_equal(6, Account.selection.count)
  end
  
  test "status valid" do
    assert_equal('Active',accounts(:one).formatted_status)
    assert_equal('New',accounts(:four).formatted_status)
    assert_equal('Deleted',accounts(:six).formatted_status)
  end
  
  test "status invalid" do
    account = accounts(:one)
    account.status = 'X'
    assert_equal('Invalid status - X',account.formatted_status)
    account.status = nil
    assert_equal('Invalid status - nil',account.formatted_status)
  end
end
