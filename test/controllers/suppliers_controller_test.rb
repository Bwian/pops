require 'test_helper'

class SuppliersControllerTest < ActionController::TestCase

  setup do
    setup_admin_session
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suppliers)
  end

  test "should get new" do
    get :new
    assert_redirected_to suppliers_path
  end

end
