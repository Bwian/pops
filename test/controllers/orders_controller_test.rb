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
    assert_equal('Creator', order_filter.role)
    assert_nil(order_filter.draft)
    assert_nil(order_filter.submitted)
    assert_nil(order_filter.approved)
    assert_nil(order_filter.processed)
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
    assert_redirected_to orders_path  
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
    assert_redirected_to orders_path
  end

  test "should not update order" do
    @order.supplier_id = nil
    put :update, id: @order.to_param, order: @order.attributes
    assert_response :success
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order.to_param
    end

    assert_redirected_to orders_path
  end
end
