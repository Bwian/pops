class NotesController < ApplicationController
  
  # GET /notes
  def index
    if params[:note]
      @note = Note.new(note_params)    
      @notes = Note.where(nil)
      @notes = @notes.by_order(@note.order_id) if @note.order_id
      @notes = @notes.by_user(@note.user_id) if @note.user_id
      @notes = @notes.by_info(@note.info) unless @note.info.empty?
      @notes = @notes.by_date(@note.date_from,@note.date_to) unless @note.date_from.empty? && @note.date_to.empty?
      @notes = @notes.paginate(page: params[:page], per_page: 10) 
    
      flash.alert = "No records found" if @notes.empty?
    else
      @notes = Note.none
      @note = Note.new
    end
  end
  
  private
  
  def note_params
    params.require(:note).permit(
      :order_id,
      :user_id,
      :info,
      :updated_at,
      :date_from,
      :date_to,
      :page)
  end

end
