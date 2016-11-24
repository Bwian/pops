module ReceiptsHelper
  
  def receipt_amount(item)
    sprintf("%.2f",item.price - item.receipt_total)
  end
end