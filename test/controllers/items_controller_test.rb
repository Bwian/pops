require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    setup_admin_session
    @item = items(:one)
  end
  
  test "should show item" do
    get :show, id: @item.to_param
    assert_response :success
  end
  
  test "should save json" do
    get :show, id: @item.to_param
    assert_equal('First Draft Item',session[:item_changes]['description'])
  end
end
