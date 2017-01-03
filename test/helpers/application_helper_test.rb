require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
   
  SHOULD    = 'should'
  SHOULDNT  = 'should not'
  
  DRAFT     = 'draft'
  SUBMIT    = 'submit'
  APPROVE   = 'approve'
  RECEIVE   = 'receive'
  PROCESS   = 'complete'
  
  ANYONE    = 'anyone'
  
  setup do
    setup_admin_session
    @order = orders(:draft)
    @service = tbr_services(:both)
  end
  
  test "link_list" do
    assert_match('',link_list(nil))
    assert_match(/Orders/,link_list(@order))
    assert_match(/TBR Services/,link_list(@service))
  end
  
  test "link_model" do
    assert_match('',link_model(nil))
    assert_match(/Order/,link_model(@order))
    assert_match(/TBR Service/,link_model(@service))
  end
  
  test "link_new" do
    assert_match(/New Order/,link_new(Order))
    assert_match(/TBR Service/,link_new(TbrService))   
  end
  
  test "link_refresh" do
    params[:controller] = 'supplier'
    assert_match(/Refresh Suppliers/,link_refresh)
  end
  
  test "link_edit" do
    assert_match('',link_edit(nil))
    assert_match(/orders(.*)edit/,link_edit(@order))
  end
  
  test "link_delete" do
    assert_match('',link_delete(nil))
    assert_match(/delete(.*)orders/,link_delete(@order))
  end
  
  test "submit_label" do
    assert_match('',submit_label(nil))
    assert_match('Update Order',submit_label(@order))
    assert_match('Update TBR Service',submit_label(@service))
    @order = Order.new
    @service = TbrService.new
    assert_match('Create Order',submit_label(@order))
    assert_match('Create TBR Service',submit_label(@service))
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
  
  test "authorised_action orders(submitted) - edit delete" do 
    order = orders(:submitted)
    order_authorised(order,:brian)
    order_not_authorised(order,:sean)
  end
  
  test "authorised_action items(submitted) - new edit delete" do 
    order = orders(:submitted)
    item_authorised(order,:brian)
    item_not_authorised(order,:sean)
  end
  
  test "authorised_action items(approved) - new edit delete" do 
    order = orders(:approved)
    item_authorised(order,:brian)
    item_not_authorised(order,:sean)
  end
  
  test "authorised_action items(received) - new edit delete" do 
    order = orders(:received)
    item_authorised(order,:brian)
    item_not_authorised(order,:sean)
  end
  
  test "authorised_action orders(processed) - edit delete" do 
    order_not_authorised(orders(:processed),:brian)
  end
  
  test "authorised_action items(processed) - new edit delete" do 
    item_not_authorised(orders(:processed),:brian)
  end
  
  test "authorised_status_change - to draft" do
    order = orders(:approved)
    assert_not(authorised_status_change(DRAFT,order),assert_message(ANYONE,order,DRAFT,SHOULDNT))
    
    order = orders(:submitted)
    setup_user_session(:sean)
    assert(authorised_status_change(DRAFT,order),assert_message(:sean,order,DRAFT,SHOULD))
    
    setup_user_session(:brian)
    assert(authorised_status_change(DRAFT,order),assert_message(:brian,order,DRAFT,SHOULD))
    
    setup_user_session(:invalid)
    assert_not(authorised_status_change(DRAFT,order),assert_message(:invalid,order,DRAFT,SHOULDNT))
  end
  
  test "authorised_status_change - to submitted" do
    order = orders(:submitted)
    assert_not(authorised_status_change(SUBMIT,order),assert_message(ANYONE,order,SUBMIT,SHOULDNT))
    
    order = orders(:draft)
    setup_user_session(:brian)
    assert(authorised_status_change(SUBMIT,order),assert_message(:brian,order,SUBMIT,SHOULD))
    
    order = orders(:approved)
    assert(authorised_status_change(SUBMIT,order),assert_message(:brian,order,SUBMIT,SHOULD))
    
    setup_user_session(:processor)
    assert(authorised_status_change(SUBMIT,order),assert_message(:processor,order,SUBMIT,SHOULD))
  end
  
  test "authorised_status_change - to submitted no items" do
    order = orders(:no_items)
    assert_not(authorised_status_change(SUBMIT,order),'Submit should fail - no items')
  end
  
  test "authorised_status_change - to approved" do
    order = orders(:draft)
    assert_not(authorised_status_change(APPROVE,order),assert_message(ANYONE,order,APPROVE,SHOULDNT))
    
    order = orders(:submitted)
    setup_user_session(:brian)
    assert(authorised_status_change(APPROVE,order),assert_message(:brian,order,APPROVE,SHOULD))
  end
  
  test "authorised_status_change - to received" do
    order = orders(:draft)
    assert_not(authorised_status_change(RECEIVE,order),assert_message(ANYONE,order,RECEIVE,SHOULDNT))
    
    order = orders(:approved)
    setup_user_session(:sean)
    assert(authorised_status_change(RECEIVE,order),assert_message(ANYONE,order,RECEIVE,SHOULD))
  end
  
  test "authorised_status_change - to processed" do
    order = orders(:draft)
    assert_not(authorised_status_change(PROCESS,order),assert_message(ANYONE,order,PROCESS,SHOULDNT))
    
    order = orders(:received)
    setup_user_session(:processor)
    assert(authorised_status_change(PROCESS,order),assert_message(:processor,order,PROCESS,SHOULD))
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
    assert(authorised_action(NEW, ITEMS, order),assert_message(user,order,NEW,SHOULD))
    assert(authorised_action(EDIT, ITEMS, item),assert_message(user,order,EDIT,SHOULD))
    assert(authorised_action(DELETE, ITEMS, item),assert_message(user,order,DELETE,SHOULD))
  end
  
  def item_not_authorised(order,user)
    setup_user_session(user)
    item = Item.new
    item.order_id = order.id
    assert_not(authorised_action(NEW, ITEMS, order),assert_message(user,order,NEW,SHOULDNT))
    assert_not(authorised_action(EDIT, ITEMS, item),assert_message(user,order,EDIT,SHOULDNT))
    assert_not(authorised_action(DELETE, ITEMS, item),assert_message(user,order,DELETE,SHOULDNT))
  end
  
  def assert_message(user,order,action,type)
    "#{action.titleize} #{type} succeed for #{OrderStatus.status(order.status)} order when user is #{user.to_s}"
  end
end
