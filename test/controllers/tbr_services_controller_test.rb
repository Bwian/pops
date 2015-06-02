require 'test_helper'

class TbrServicesControllerTest < ActionController::TestCase
  setup do
    setup_admin_session
    @tbr_service = tbr_services(:both)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tbr_services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tbr_service" do
    @tbr_service.user = @tbr_service.manager
    assert_difference('TbrService.count') do
      post :create, tbr_service: @tbr_service.attributes
    end

    assert_redirected_to tbr_services_path
  end

  test "should show tbr_service" do
    get :show, id: @tbr_service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tbr_service
    assert_response :success
  end

  test "should update tbr_service" do
    @tbr_service.user = @tbr_service.manager
    patch :update, id: @tbr_service, tbr_service: @tbr_service.attributes
    assert_redirected_to tbr_services_path
  end

  test "should destroy tbr_service" do
    assert_difference('TbrService.count', -1) do
      delete :destroy, id: @tbr_service
    end

    assert_redirected_to tbr_services_path
  end
end
