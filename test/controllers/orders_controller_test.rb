require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    setup_admin_session
    @supplier = suppliers(:two)
    @order = orders(:draft)
    @user = users(:brian)
  end

  test "initial order_filter setup" do
    order_filter = session[:order_filter]
    assert_equal(OrderStatus::PROCESSOR, order_filter.role)
    assert_equal('0', order_filter.draft)
    assert_equal('0', order_filter.submitted)
    assert_equal('1', order_filter.approved)
    assert_equal('0', order_filter.processed)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    order = Order.new
    order.supplier = @supplier
    order.status = OrderStatus::DRAFT
    order.creator = @creator
    
    assert_difference('Order.count') do
      post :create, order: order.attributes
    end
    assert_redirected_to new_order_item_path(Order.last)
  end

  test "should not create order" do
    order = Order.new

    assert_no_difference('Order.count') do
      post :create, order: order.attributes
    end
    assert_response :success
  end

  test "should show order" do
    get :show, id: @order.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order.to_param
    assert_response :success
  end

  test "should update order" do
    put :update, id: @order.to_param, order: @order.attributes
    assert_redirected_to order_path(@order)
  end

  test "should not update order" do
    @order.supplier_id = nil
    put :update, id: @order.to_param, order: @order.attributes
    assert_response :success
  end

  test "should destroy order" do
    get :show, id: @order.to_param  # setup session[:order_changes] first
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order.to_param
    end

    assert_redirected_to orders_path
  end
  
  test "should change default to submitted" do
    assert_difference("Order.where(status: 'S').count", 1) do
      put :submit, id: @order.to_param, order: @order.attributes
    end
    assert_redirected_to orders_path
  end
  # TODO: change to handle js call
  # test "should change submitted to draft" do
  #   @order = orders(:submitted)
  #   assert_difference("Order.where(status: 'D').count", 1) do
  #     patch :redraft, id: @order.to_param, order: @order.attributes
  #   end
  #   assert_redirected_to order_path
  # end
end
