class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  validates :order_id, 
            :program_id, 
            :account_id, 
            :tax_rate_id, 
            :description, 
            :quantity, 
            :price, 
            presence: true

  def subtotal
    quantity.nil? || price.nil? ? 0.00 : quantity.to_f * price.to_f
  end
  
  def gst
    rate = tax_rate_id ? tax_rate.rate : 0.0
    subtotal * rate.to_f / 100.0
  end
  
  def total
    subtotal + gst
  end
end
