require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @draft = orders(:draft)
    @item1 = items(:one)
    @item2 = items(:two)
  end
  
  test 'item count' do
    assert_equal(2,@draft.items.size)
  end
  
  test 'any?' do
    assert(@draft.items.any?)
    assert(!orders(:invalid).items.any?)
  end
  
  test 'total with gst' do
    assert_equal(10.89, @item1.total)
  end
  
  test 'total without gst' do
    assert_equal(9.99, @item2.total)
  end
  
end
