class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  has_many :order_items
  
  validates :supplier_id, :status, presence: true
    
  def status_name
    OrderStatus.status(status)
  end
  
  def atby
    rval = "created #{build_atby(created_at,creator)}"
    rval += "<br/>approved #{build_atby(approveded_at,approver)}" if approved_at
    rval += "<br/>processed #{build_atby(processed_at,processor)}" if processed_at  
    rval.html_safe
  end
  
  private
  
  def build_atby(onat,by)
    "on #{onat.strftime('%d/%m/%Y')} at #{onat.strftime('%H:%M')} by #{by.code}"
  end
end
