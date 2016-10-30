require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  setup do
    @order = orders(:submitted)
    @note = notes(:one)
    @brian = users(:brian)
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
  
  test 'by_order' do
    assert_equal(2,Note.by_order(@order).count)
  end
  
  test 'by_order deleted' do
    assert_equal(1,Note.by_order(1).count)
  end
  
  test 'by_user' do
    assert_equal(2,Note.by_user(@brian).count)
  end
  
  test 'by_info' do
    assert_equal(2,Note.by_info('more').count)
  end
  
  test 'by combination' do
    notes = Note.by_user(@brian)
    assert_equal(1,notes.by_info('more').count,'user and info')
    notes = Note.by_order(@order)
    assert_equal(1,notes.by_info('more').count,'order and info')
  end
  
  test 'by_date' do
    assert_equal(2,Note.by_date('11/08/2014','12/08/2014').count,'between')
    assert_equal(1,Note.by_date('','10/08/2014').count,'to only')
    assert_equal(3,Note.by_date('11/08/2014','').count,'from only')
  end
  
  test 'valid dates' do
    @note.date_from = '1/2/2014'
    assert_equal('01/02/2014',@note.date_from,'1/2/2014')
    @note.date_from = '1-2-2014'
    assert_equal('01/02/2014',@note.date_from,'1-2-2014')
    @note.date_from = '1/2/14'
    assert_equal('01/02/2014',@note.date_from,'1/2/14')
    @note.date_from = '1/2'
    assert_equal('01/02/2016',@note.date_from,'1/2')
    @note.date_from = '2014'
    assert_equal('01/01/2014',@note.date_from,'2014')
    @note.date_from = '14'
    assert_equal('01/01/2014',@note.date_from,'14')
    @note.date_from = ''
    assert_equal('',@note.date_from,'empty')
    @note.date_from = nil
    assert_equal('',@note.date_from,'nil')
  end

  test 'invalid dates' do
    @note.date_from = 'x/y'
    assert_equal('',@note.date_from,'x/y')
    assert(@note.errors.any?)
    @note.date_from = '!@#'
    assert_equal('',@note.date_from,'!@#')
    assert(@note.errors.any?)
    @note.date_from = (Date.today.year - 1998).to_s
    assert_equal('',@note.date_from,'Year after next')
    assert(@note.errors.any?)
    @note.date_from = '1999'
    assert_equal('',@note.date_from,'1999')
    assert(@note.errors.any?)
  end
  
end
