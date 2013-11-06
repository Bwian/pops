require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    brian = users(:brian)
    session[:return_to] = '/admin'
    post :create, code: brian.code, password: 'secret'
    assert_redirected_to '/admin'
    assert_equal brian.id, session[:user_id]
  end

  test "should fail login" do
    brian = users(:brian)
    post :create, code: brian.code, password: 'wrong'
    assert_redirected_to login_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to login_url
  end
end
