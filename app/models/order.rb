class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  
  validates :supplier_id, :status, presence: true
    
  def status_name
    OrderStatus.status(status)
  end
end
