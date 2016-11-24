class ReceiptsController < ApplicationController
  
  skip_before_filter :authorise, :timeout
  
  def new
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.find(params[:id])
    redirect_to order_url(@order.id)
  end

  private
  
  def receipts_params
    params.require(:order).permit(
      :supplier_id,
      {:receipts => []}
      ) 
  end
end
