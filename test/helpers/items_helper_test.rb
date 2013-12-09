require 'test_helper'

class ItemsHelperTest < ActionView::TestCase
  
  setup do
    @item1 = items(:one)
    @item2 = items(:two)
  end
  
  test 'default tax rate - already set' do
    assert_equal(32,default_tax_rate(@item1))
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
  
end
