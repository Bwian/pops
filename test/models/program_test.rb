require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(2, Program.selection.count)
    
    supplier = Program.new
    supplier.name = 'New Supplier'
    supplier.save
    
    assert_equal(2, Program.selection.count)
    Program.reset_selection
    assert_equal(3, Program.selection.count)
  end
end
