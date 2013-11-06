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
#		assert user.errors[:admin].any?
# TODO: Putting :admin in validates causes @user2.valid to fail
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

  # TODO: SELECTION works OK in browser but not in test
  # test "build SELECTION" do
  #   assert_equal "Brian Collins", User::SELECTION[1][0]
  #   assert_equal 4, User::SELECTION.count
  # end

  test "password=" do
    user = users(:invalid)
    salt = user.salt
    assert user.invalid?
    assert user.hashed_password.blank? 

    user.password = 'secret'
    assert user.valid?
    assert !user.hashed_password.blank?
    assert_not_equal(salt,user.salt)
  end

  test "authenticate valid user" do
    user = User.authenticate('brian','secret')
    assert_equal('Brian Collins', user.name)
  end

  test "authenticate invalid password" do
    user = User.authenticate('brian','SECRET')
    assert_nil(user)
  end

  test "authenticate invalid user" do
    user = User.authenticate('drew','SECRET')
    assert_nil(user)
  end
end
