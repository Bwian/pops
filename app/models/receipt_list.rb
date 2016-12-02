class ReceiptList
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :order, :receipts, :notes
  
  def initialize(user_id,params)
    @order = Order.find(params[:id])
    @receipts = params[:receipts]
    @notes = ''
    @user_id = user_id
  end
  
  def save
    @receipts.each_key do |item_id|
      price = @receipts[item_id].to_f
      next if price < 0.01
      
      receipt = Receipt.new
      receipt.item_id = item_id
      receipt.receiver_id = @user_id
      receipt.price = price
      receipt.save
      
      receipt.errors.messages.each do |key,value|
        value.each { |message| @order.errors.add(key,message) }
      end
    end
    
    return false if @order.errors.any?
    
    if @order.formatted_receipt_total == @order.formatted_grandtotal
      @notes = 'Order completely received'
    else
      @notes = "Order partially received. $#{sprintf('%.2f',@order.grandtotal - @order.receipt_total)} outstanding."
    end
    
    @order.to_received(@user_id)
  end
end