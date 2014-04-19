require 'test_helper'

class ItemsHelperTest < ActionView::TestCase
  
  setup do
    @order = orders(:draft)
    @account = accounts(:two)
  end
  
  test 'default tax rate - already set' do
    assert_equal(32,default_tax_rate(items(:one)))
  end
  
  test 'default tax rate - supplier auto' do
    item = Item.new
    item.order = @order
    assert_equal(32,default_tax_rate(item))
  end
  
  test 'default tax rate - supplier set' do
    item = Item.new
    item.order = orders(:submitted)
    assert_equal(34,default_tax_rate(item))
  end
  
  test 'default tax rate - account set' do
    item = Item.new
    item.order = @order
    item.account = @account
    assert_equal(33,default_tax_rate(item))
  end
  
  test 'tax rate select - processor' do
    setup_admin_session
    item = Item.new
    item.order = @order
    item.account = @account
    assert tax_rate_select(item,true).include?("selected=\"selected\" value=\"33\"")
  end
  
  test 'tax rate select - creator - new item' do
    setup_creator_session
    item = Item.new
    item.order = @order
    assert_not tax_rate_select(item,true).include?("value=\"33\"")
  end
  
  test 'tax rate select - creator - extra tax rate' do
    setup_creator_session
    item = items(:four)
    assert tax_rate_select(item,true).include?("value=\"33\"")
  end
  
  test 'tax rate select - creator - normal tax rate' do
    setup_creator_session
    item = items(:one)
    assert_not tax_rate_select(item,true).include?("value=\"33\"")
  end
  
  test 'account_select - filtered' do
    setup_admin_session
    item = Item.new
    item.order = @order
    assert account_select(item,true,true).include?("Account Three")
    assert_not account_select(item,true,true).include?("Account Two")
  end
  
  test 'account_select - unfiltered' do
    setup_creator_session
    item = Item.new
    item.order = @order
    assert account_select(item,true,true).include?("Account One")
  end
  
  test 'account_select - extra' do
    setup_admin_session
    item = items(:four)
    assert account_select(item,true,true).include?("Account Five")
  end
  
  test 'program_select - filtered' do
    setup_admin_session
    item = Item.new
    item.order = @order
    assert program_select(item,true).include?("Program Three")
    assert_not program_select(item,true).include?("Program Two")
  end
  
  test 'program_select - unfiltered' do
    setup_creator_session
    item = Item.new
    item.order = @order
    assert program_select(item,true).include?("Program One")
  end
  
  test 'program_select - extra' do
    setup_admin_session
    item = items(:four)
    assert program_select(item,true).include?("Program Five")
  end
end
