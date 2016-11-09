class Receipt < ActiveRecord::Base
  belongs_to :item
  belongs_to :receiver, :class_name => 'User'
  
  default_scope { order('created_at ASC') }
  
  validates :item_id,  
            :status,
            :receiver_id,
            :price, 
            presence: true

  validate :over_price
  
  def over_price
    item = Item.find(self.item_id)
    remaining_price = item.price - item.receipt_total
    errors.add(:price, "for #{item.description} must not exceed $#{remaining_price}") if price > remaining_price
  end            
end
