class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  default_scope { order('created_at DESC') }
  
  validates :order_id, 
            :program_id, 
            :account_id, 
            :tax_rate_id, 
            :description, 
            :price, 
            presence: true
  
  def gst
    rate = tax_rate_id ? tax_rate.rate : 0.0
    price * rate.to_f / (100.0 + rate.to_f)
  end
  
end
