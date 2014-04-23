class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  default_scope { order('created_at ASC') }
  
  validates :order_id, 
            :program_id, 
            :account_id, 
            :tax_rate_id, 
            :description, 
            :price, 
            presence: true
  
  def gst
    rate = self.tax_rate_id ? self.tax_rate.rate : 0.0
    p = self.price ? self.price : 0.0
    p * rate.to_f / (100.0 + rate.to_f)
  end
  
  def formatted_gst
    sprintf('%.2f', self.gst)
  end
  
  def subtotal
    price - gst
  end
  
  def formatted_subtotal
    price.nil? ? '' : sprintf('%.2f', self.subtotal)
  end
  
  def formatted_price
    price.nil? ? '' : sprintf('%.2f', self.price)
  end
    
end
