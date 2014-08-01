require 'test_helper'

class NotesHelperTest < ActionView::TestCase
  
  include NotesHelper
  
  setup do
    setup_admin_session
    @order = orders(:submitted)
    save_json('order',@order)
  end
  
  test "save_json" do
    assert_equal('brian',session[:order_changes]['approver'],'Set session')
    save_json('order',nil)
    assert_nil(session[:order_changes],'Clear session')
  end
  
  test "add_notes - no change" do
    note_count = @order.notes.size
    add_notes('order',@order)
    assert_equal(note_count,@order.notes.size,'No note added')
    assert_nil(session[:order_changes],'Clear session')
  end
  
  test "add_notes - change" do
    note_count = @order.notes.size
    @order.reference = 'Brian'
    add_notes('order',@order)
    assert_equal(note_count + 1,@order.notes.size,'Note added')
    note = @order.notes.first
    assert(note.info =~ /Brian/,'Note contents')
  end
  
  test "save_user_notes" do
    note_count = @order.notes.size
    params[:order_notes] = "User note test"
    params[:id] = @order.id
    save_user_notes(params)
    assert_equal(note_count + 1,@order.notes.size,'Note added')
    note = @order.notes.first
    assert_equal("User note test",note.info,'Note contents')
  end
  
  test "save_notes" do
    note_count = @order.notes.size
    save_notes(@order.id,"General note test")
    assert_equal(note_count + 1,@order.notes.size,'Note added')
    note = @order.notes.first
    assert_equal("General note test",note.info,'Note contents')
  end
  
  test "diff_model - no change" do
    assert_equal('',diff_model(:order_changes,@order))
  end
  
  test "diff_model - change" do
    @order.reference = 'Brian'
    assert(diff_model(:order_changes,@order) =~ /Brian/)
  end
end
