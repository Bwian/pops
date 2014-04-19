require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  test "selection and reset" do
    assert_equal(5, Program.selection.count)
    
    program = Program.new
    program.name = 'New Supplier'
    program.save
    
    assert_equal(5, Program.selection.count)
    Program.reset_selection
    assert_equal(6, Program.selection.count)
  end
end
