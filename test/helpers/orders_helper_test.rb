require 'test_helper'
include ApplicationHelper

class OrdersHelperTest < ActionView::TestCase
  setup do
    setup_admin_session
    @order = orders(:draft)
  end
  
  test "link_action draft" do
    links = link_action(@order)
    assert_equal(1,links.size)
    assert_match(/submit/,links[0])
  end
  
  test 'order_actions show' do
    actions = order_actions(@order,true)
    assert_equal(3,actions.size)
    assert_match(/Edit/,actions[2])
  end
  
  test 'order_actions edit' do
    actions = order_actions(@order,false)
    assert_equal(2,actions.size)
    assert_match(/Update Order/,actions[0])
  end
  
  test 'order_actions create' do
    @order.id = nil
    actions = order_actions(@order,false)
    assert_equal(2,actions.size)
    assert_match(/Create Order/,actions[0])
  end
  
  test "roles" do
    assert_equal(3,roles.size)
    session[:user_id] = users(:sean).id
    assert_equal(1,roles.size)
  end

  test 'order_header no sort' do
    session[:sort_by] = 'status'
    assert_equal('PO Number ', order_header(:id))
  end
  
  test 'order_header invalid key' do
    assert_equal(' ', order_header(:invalid))
  end  
  
  test 'order_header ascending' do
    session[:sort_by] = 'status'
    session[:sort_order] = 'asc'   
    assert_equal('Status &uarr;', order_header(:status))
  end
  
  test 'order_header desscending' do
    session[:sort_by] = 'status'
    session[:sort_order] = 'desc'   
    assert_equal('Status &darr;', order_header(:status))
  end
  
  test 'order_sort_header' do
    assert_includes(order_sort_header(:id), 'orders?sort=id')
  end
end
