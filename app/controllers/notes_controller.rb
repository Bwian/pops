class NotesController < ApplicationController
  
  # GET /notes
  def index
    @notes = Note.none
    @note = Note.new
  end

  # POST /notes
  def search
    @note = Note.new(note_params)
    @notes = Note.where(nil)
    @notes = @notes.by_order(@note.order_id) if @note.order_id
    @notes = @notes.by_user(@note.user_id) if @note.user_id
    @notes = @notes.by_info(@note.info) unless @note.info.empty?
    @notes = @notes.by_date(@note.date_from,@note.date_to) unless @note.date_from.empty? && @note.date_to.empty?
     
    flash.alert = "No records found" if @notes.size == 0
    render action: 'index'
  end
  
  private
  
  def note_params
    params.require(:note).permit(
      :order_id,
      :user_id,
      :info,
      :updated_at,
      :date_from,
      :date_to)
  end

end
