require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase

  setup do
    setup_admin_session
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:models)
  end

  test "should get new" do
    get :new
    assert_redirected_to programs_path
  end

end
