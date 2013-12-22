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
  
  test "link_edit" do
    assert_match(/orders(.*)edit/,link_edit(@order))
  end
  
  test "link_delete" do
    assert_match(/orders/,link_delete(@order))
    assert_match(/delete/,link_delete(@order))
  end
  
  test "index_header" do
    assert_match(/Orders(.*)New Order/,index_header('order',7))
  end
  
  test "index_header_refresh" do
    assert_match(/Orders(.*)Refresh/,index_header_refresh('order',7))
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
end
