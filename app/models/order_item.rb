class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  validates :order_id, :program, :description, :quantity, :price, presence: true
end
