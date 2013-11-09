require 'test_helper'

class SupplierTest < ActiveSupport::TestCase

  test "selection and reset" do
    assert_equal(2, Supplier.selection.count)
    
    supplier = Supplier.new
    supplier.name = 'New Supplier'
    supplier.save
    
    assert_equal(2, Supplier.selection.count)
    Supplier.reset_selection
    assert_equal(3, Supplier.selection.count)
  end
  
  test "address" do
    supplier = suppliers(:zero)
    assert_equal('105&nbsp;Dana&nbsp;Street, Ballarat&nbsp;Vic&nbsp;3350',supplier.address)
  end
  
  
end
