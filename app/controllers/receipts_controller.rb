class ReceiptsController < ApplicationController
  
  include NotesHelper
  
  skip_before_filter :authorise
  
  def new
    @order = Order.find(params[:id])
  end
  
  def create
    receipt_list = ReceiptList.new(session[:user_id],params)
    @order = receipt_list.order
    receipt_list.save 
    add_notes('order',@order) if @order.notes.any?
    @order.save unless @order.errors.any? 
    
    respond_to do |format|
      if @order.errors.any?
        format.html { render :new }
      else
        save_notes(@order.id,receipt_list.notes)
        save_notes(@order.id,params[:notes]) unless params[:notes].empty?
        format.html { redirect_to order_url(@order.id) }
      end
    end
  end
end
