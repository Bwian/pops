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
  
  test "should destroy item" do
    get :show, id: @item.to_param  # setup session[:order_changes] first
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item.to_param
    end
    assert_redirected_to order_path(@item.order_id, notice: 'Item was successfully deleted.')
  end
end
