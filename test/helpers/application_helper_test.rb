require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
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
  
  test "authorised_action other" do 
    setup_user_session(:brian)
    assert(authorised_action(nil, 'users', nil))
    setup_user_session(:sean)
    assert_not(authorised_action(nil, 'users', nil))
  end
  
  test "authorised_action orders new" do 
    setup_user_session(:sean)
    assert(authorised_action('new', 'orders', nil),:sean)
    setup_user_session(:invalid)
    assert_not(authorised_action('new', 'orders', nil),:invalid)
  end
  
  test "authorised_action orders(draft) - edit delete" do 
    order = orders(:draft)
    
    setup_user_session(:brian)
    assert(authorised_action('edit', 'orders', order),'edit brian')
    assert(authorised_action('delete', 'orders', order),'delete brian')
    
    setup_user_session(:sean)
    assert_not(authorised_action('edit', 'orders', order),'edit sean')
    assert_not(authorised_action('delete', 'orders', order),'delete sean')
  end
  
  test "authorised_action items(draft) - edit delete" do 
    order = orders(:draft)
    item = Item.new
    item.order_id = order.id
    
    setup_user_session(:brian)
    assert(authorised_action('new', 'items',  order),'new brian')
    assert(authorised_action('edit', 'items', item),'edit brian')
    assert(authorised_action('delete', 'items', item),'delete brian')
    
    setup_user_session(:sean)
    assert_not(authorised_action('new', 'items',  order),'new sean')
    assert_not(authorised_action('edit', 'items', item),'edit sean')
    assert_not(authorised_action('delete', 'items', item),'delete sean')
  end
  
  test "authorised_action orders(processed) - edit delete" do 
    setup_user_session(:brian)
    order = orders(:processed)
    assert_not(authorised_action('edit', 'orders', order),'edit')
    assert_not(authorised_action('delete', 'orders', order),'delete')
  end
  
  test "authorised_action items(processed) - new edit delete" do 
    setup_user_session(:brian)
    order = orders(:processed)
    item = Item.new
    item.order_id = order.id
    assert_not(authorised_action('new', 'items',  order),'new')
    assert_not(authorised_action('edit', 'items', item),'edit')
    assert_not(authorised_action('delete', 'items', item),'delete')
  end
  
  private
  
  def setup_user_session(code)
    user = users(code)
    session[:user_id] = user.id
    session[:admin] = user.admin
  end
end
