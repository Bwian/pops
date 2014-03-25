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
  
  test 'gst' do
    assert_in_delta(0.45,@item1.gst,0.001)
    assert_in_delta(0.00,@item2.gst,0.001)
  end
  
  test 'subtotal' do
    assert_in_delta(4.50,@item1.subtotal,0.001)
    assert_in_delta(9.99,@item2.subtotal,0.001)
  end
  
  test 'formatted_gst' do
    assert_equal('0.45',@item1.formatted_gst)
  end
  
  test 'formatted_subtotal' do
    assert_equal('4.50',@item1.formatted_subtotal)
  end
end
