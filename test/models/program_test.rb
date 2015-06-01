require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  setup do
    Rails.cache.delete(Program::CACHE_KEY)
  end
  
  test "selection and reset" do
    assert_equal(5, Program.selection.count)
    
    program = Program.new
    program.name = 'New Program'
    program.status = 'N'
    program.save
      
    assert_equal(6, Program.selection.count)
  end
end
