require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  setup do
    @user = users(:brian)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do    
    session[:return_to] = '/admin'
    post :create, code: @user.code, password: 'secret'
    assert_redirected_to '/admin'
    assert_equal @user.id, session[:user_id]
  end

  test "should fail login" do
    post :create, code: 'unknown', password: 'wrong'
    assert_redirected_to login_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to login_url
  end
end
