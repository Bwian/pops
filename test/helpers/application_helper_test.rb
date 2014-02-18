require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  NEW       = 'new'
  EDIT      = 'edit'
  DELETE    = 'delete'
  
  ORDERS    = 'orders'
  ITEMS     = 'items'
  
  SHOULD    = 'should'
  SHOULDNT  = 'should not'
  
  setup do
    setup_admin_session
    @order = orders(:draft)
  end
  
  test "link_list" do
    assert_match(/orders/,link_list(@order))
  end
  
  test "link_model" do
    assert_match(/Order/,link_model(@order))
  end
  
  test "link_new" do
    assert_match(/New Order/,link_new('order'))
  end
  
  test "link_refresh" do
    assert_match(/Refresh Suppliers/,link_refresh('supplier'))
  end
  
  test "link_edit" do
    assert_match(/orders(.*)edit/,link_edit(@order))
  end
  
  test "link_delete" do
    assert_match(/orders/,link_delete(@order))
    assert_match(/delete/,link_delete(@order))
  end
  
  test "legend edit" do
    assert_equal('Enter Order',legend('Order',false))
  end
  
  test "legend show" do
    assert_equal('Order',legend('Order',true))
  end
  
  test "format_date nil" do
    assert_equal('',format_date(nil))
    assert_match(/..\/..\/..../,format_date(Time.now))
  end
  
  test "authorised_action admin" do 
    setup_user_session(:brian)
    assert(authorised_action(nil, 'users', nil),'Admin actions should succeed for user brian')
    setup_user_session(:sean)
    assert_not(authorised_action(nil, 'users', nil),'Admin actions should not succeed for user sean')
  end
  
  test "authorised_action orders new" do 
    setup_user_session(:sean)
    assert(authorised_action(NEW, ORDERS, nil),'Sean should be able to create orders')
    setup_user_session(:invalid)
    assert_not(authorised_action(NEW, ORDERS, nil),'Invalid should not be able to create orders')
  end
  
  test "authorised_action orders(draft) - edit delete" do 
    order = orders(:draft)
    order_authorised(order,:brian)
    order_not_authorised(order,:sean)
  end
  
  test "authorised_action items(draft) - new edit delete" do 
    order = orders(:draft)
    item_authorised(order,:brian)
    item_not_authorised(order,:sean)
  end
  
  test "authorised_action orders(processed) - edit delete" do 
    order_not_authorised(orders(:processed),:brian)
  end
  
  test "authorised_action items(processed) - new edit delete" do 
    item_not_authorised(orders(:processed),:brian)
  end
  
  private
  
  def setup_user_session(code)
    user = users(code)
    session[:user_id] = user.id
    session[:admin] = user.admin
  end
  
  def order_authorised(order,user)
    setup_user_session(user)
    assert(authorised_action(EDIT, ORDERS, order),assert_message(user,order,EDIT,SHOULD))
    assert(authorised_action(DELETE, ORDERS, order),assert_message(user,order,DELETE,SHOULD))
  end
  
  def order_not_authorised(order,user)
    setup_user_session(user)
    assert_not(authorised_action(EDIT, ORDERS, order),assert_message(user,order,EDIT,SHOULDNT))
    assert_not(authorised_action(DELETE, ORDERS, order),assert_message(user,order,DELETE,SHOULDNT))
  end
  
  def item_authorised(order,user)
    setup_user_session(user)
    item = Item.new
    item.order_id = order.id
    assert(authorised_action(NEW, ITEMS,  order),assert_message(user,order,NEW,SHOULD))
    assert(authorised_action(EDIT, ITEMS, item),assert_message(user,order,EDIT,SHOULD))
    assert(authorised_action(DELETE, ITEMS, item),assert_message(user,order,DELETE,SHOULD))
  end
  
  def item_not_authorised(order,user)
    setup_user_session(user)
    item = Item.new
    item.order_id = order.id
    assert_not(authorised_action(NEW, ITEMS,  order),assert_message(user,order,NEW,SHOULDNT))
    assert_not(authorised_action(EDIT, ITEMS, item),assert_message(user,order,EDIT,SHOULDNT))
    assert_not(authorised_action(DELETE, ITEMS, item),assert_message(user,order,DELETE,SHOULDNT))
  end
  
  def assert_message(user,order,action,type)
    "#{action.titleize} #{type} succeed for #{OrderStatus.status(order.status)} when user is #{user.to_s}"
  end
end
