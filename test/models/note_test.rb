require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  setup do
    @order = orders(:submitted)
    @note = notes(:one)
  end
  
  test 'note count' do
    assert_equal(2,@order.notes.size)
  end
  
  test 'any?' do
    assert(@order.notes.any?)
    assert_not(orders(:invalid).notes.any?)
  end
  
  test 'user_name found' do
    assert_equal('Brian Collins',@note.user_name)
  end
  
  test 'user_name not found' do
    @note.user_id = 99
    assert_equal('Missing User 99',@note.user_name)
  end
  
  test 'formatted_date' do
    assert(@note.formatted_date =~ /\d{2}\/\d{2}\/\d{4} - \d{2}:\d{2}/)
  end
  
  test 'formatted_notes' do
    assert(@order.formatted_notes =~ /More stuff/)
    assert_equal(4,@order.formatted_notes.lines.count)
  end
end
