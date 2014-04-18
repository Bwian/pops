require 'test_helper'

class ItemsHelperTest < ActionView::TestCase
  
  test 'default tax rate - already set' do
    assert_equal(32,default_tax_rate(items(:one)))
  end
  
  test 'default tax rate - supplier auto' do
    item = Item.new
    item.order = orders(:draft)
    assert_equal(32,default_tax_rate(item))
  end
  
  test 'default tax rate - supplier set' do
    item = Item.new
    item.order = orders(:submitted)
    assert_equal(34,default_tax_rate(item))
  end
  
  test 'default tax rate - account set' do
    item = Item.new
    item.order = orders(:draft)
    item.account = accounts(:two)
    assert_equal(33,default_tax_rate(item))
  end
  
  test 'tax rate select - processor' do
    setup_admin_session
    item = Item.new
    item.order = orders(:draft)
    item.account = accounts(:two)
    assert tax_rate_select(item,true).include?("selected=\"selected\" value=\"33\"")
  end
  
  test 'tax rate select - creator - new item' do
    setup_creator_session
    item = Item.new
    item.order = orders(:draft)
    assert_not tax_rate_select(item,true).include?("value=\"33\"")
  end
  
  test 'tax rate select - creator - other tax rate' do
    setup_creator_session
    item = items(:four)
    assert tax_rate_select(item,true).include?("value=\"33\"")
  end
  
  test 'tax rate select - creator - normal tax rate' do
    setup_creator_session
    item = items(:one)
    assert_not tax_rate_select(item,true).include?("value=\"33\"")
  end
end
