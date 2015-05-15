require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:brian)
    @user2 = users(:sean)
  end

  test "getters" do
    assert_equal "brian", @user1.code
    assert_equal "Brian Collins", @user1.name
    assert_equal "brian", @user1.code
  end
  
  test "attributes must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?
    assert user.errors[:code].any?
  end

  test "unique name and code" do
    assert @user2.valid?

    @user2.name = @user1.name
    assert @user2.invalid?
    assert_equal "has already been taken", @user2.errors[:name].join('; ')

    @user2.code = @user1.code
    assert @user2.invalid?
    assert_equal "has already been taken", @user2.errors[:code].join('; ')
  end
  
  test "caching and adding users" do
    Rails.cache.clear
    count = User.users.count
    assert_equal(5,count)
    add_user
    assert_equal(count + 1, User.users.count)
  end
  
  test "caching and adding approvers" do
    Rails.cache.clear
    count = User.approvers.count
    assert_equal(1,count)
    add_user
    assert_equal(count + 1, User.approvers.count)
  end
  
  test "caching and adding tbr_managers" do
    Rails.cache.clear
    count = User.tbr_managers.count
    assert_equal(0,count)
    add_user
    assert_equal(count + 1, User.tbr_managers.count)
  end
  
  test "roles" do
    assert_equal(3,@user1.roles.size)
    assert_equal('Processor',@user1.roles[0])
    assert_equal(1,@user2.roles.size)
    assert_equal('Processor',@user1.roles[0])
  end
  
  test "first_name" do
    assert_equal('Brian',@user1.first_name)
  end
  
  test "invalid accounts filter" do
    @user1.accounts_filter = '1234x' 
    assert_not(@user1.valid?)
  end
  
  test "invalid programs filter" do
    @user1.programs_filter = '1234x' 
    assert_not(@user1.valid?)
  end
  
  private
  
  def add_user
    user = User.new
    user.code = 'test'
    user.name = 'Test Name'
    user.admin = false
    user.approver = true
    user.tbr_manager = true
    user.save
  end
end
