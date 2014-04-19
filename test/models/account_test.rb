require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(5, Account.selection.count)
    
    account = Account.new
    account.name = 'New Account'
    account.save
    
    assert_equal(5, Account.selection.count)
    Account.reset_selection
    assert_equal(6, Account.selection.count)
  end
end
