require 'test_helper'

class TaxRateTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(3, TaxRate.selection.count)
    
    tax_rate = TaxRate.new
    tax_rate.name = 'New Tax Rate'
    tax_rate.status = 'N'
    tax_rate.save
    
    assert_equal(4, TaxRate.selection.count)
  end
end
