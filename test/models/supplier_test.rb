require 'test_helper'

class SupplierTest < ActiveSupport::TestCase

  test "selection and reset" do
    assert_equal(3, Supplier.selection.count)
    
    supplier = Supplier.new
    supplier.name = 'New Supplier'
    supplier.status = 'N'
    supplier.save
    
    assert_equal(3, Supplier.selection.count)
    Supplier.reset_selection
    assert_equal(4, Supplier.selection.count)
  end
  
  test "address" do
    supplier = suppliers(:zero)
    assert_equal('105&nbsp;Dana&nbsp;Street, Ballarat&nbsp;Vic&nbsp;3350',supplier.address)
  end
  
  test "tax rate" do
    assert_equal('No GST',suppliers(:two).tax_rate.name)
  end
  
  test "payment_term" do
    assert_equal('Cash Only',suppliers(:two).payment_term.name)
  end
  
end
