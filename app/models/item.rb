class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  # validates :order_id, :program_id, :account_id, :quantity, :price
end
