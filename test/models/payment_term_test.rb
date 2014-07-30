require 'test_helper'

class PaymentTermTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(3, PaymentTerm.selection.count)
    
    payment_term = PaymentTerm.new
    payment_term.name = 'New Supplier'
    payment_term.factor = 1
    payment_term.status = 'N'
    payment_term.save
    
    assert_equal(4, PaymentTerm.selection.count)
  end
end
