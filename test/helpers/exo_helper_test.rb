require 'test_helper'

class ExoHelperTest < ActionView::TestCase
  
  setup do
    setup_admin_session
    @account = accounts(:one)
    @tax_rate = tax_rates(:none)
    params[:controller] = 'accounts'
  end
  
  test "link_exo - admin" do
    assert(/edit/ =~ link_exo(@account))
    assert(/tax_rate/ =~ link_exo(tax_rates(:none)))
  end
  
  test "link_exo - creator" do
    setup_creator_session
    assert('',link_exo(@account))
  end
  
  test "exo_status" do
    assert_equal("'#account_status'",exo_status(@account))
    assert_equal("'#tax_rate_status'",exo_status(@tax_rate),'CamelCase model') 
  end
  
  test "attribute_label" do
    assert(/Tax rate:/ =~ attribute_label('tax_rate_id'))
  end
  
  test "attribute_field - text" do
    form_for(@account) do |f|
      assert(attribute_field(f,'status').starts_with?('<input'))
      assert(/account\[status\]/ =~ attribute_field(f,'status'))
    end
  end
  
  test "attribute_field - select" do
    form_for(@account) do |f|
      assert(attribute_field(f,'tax_rate_id').starts_with?('<div'))
      assert(/account\[tax_rate_id\]/ =~ attribute_field(f,'tax_rate_id'))
    end
  end
end

