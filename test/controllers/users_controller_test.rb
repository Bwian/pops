require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    setup_admin_session
    @user = users(:brian)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    Rails.cache.delete('approvers.all')
    @user.code = "Drew"
    @user.name = "Drew Collins"
    @user.admin = false
    @user.approver = true
    
    count = User.approvers.count
    assert_difference('User.count') do
      post :create, user: @user.attributes
    end
    assert_redirected_to users_path
    assert_equal(count + 1, User.approvers.count)  
  end

  test "should not create user" do
    @user.code = nil
    @user.name = "Drew Collins"

    assert_no_difference('User.count') do
      post :create, user: @user.attributes
    end
    assert_response :success
  end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user.to_param, user: @user.attributes
    assert_redirected_to users_path
  end

  test "should not update user" do
    @user.code = nil
    put :update, id: @user.to_param, user: @user.attributes
    assert_response :success
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to users_path
  end
end
