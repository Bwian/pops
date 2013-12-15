class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  has_many :items
  
  validates :supplier_id, :status, presence: true
  validate :approver_present
  
  def approver_present
    errors.add(:approver_id, "must be present") if approver_id.nil? && status == OrderStatus::SUBMITTED
  end
    
  def status_name
    OrderStatus.status(status)
  end
  
  def atby
    notes = [ "created #{build_atby(created_at,creator)}" ]
    notes << "approved #{build_atby(approved_at,approver)}" if approved_at
    notes << "processed #{build_atby(processed_at,processor)}" if processed_at  
    notes
  end
  
  def supplier_desc
    supplier_id && supplier_id > 1 ? supplier.name : supplier_name
  end
  
  def subtotal
    grandtotal - gst
  end
  
  def gst
    total = 0.0
    items.each do |item|
      total += item.gst 
    end
    total
  end
  
  def grandtotal
    total = 0.0
    items.each do |item|
      total += item.price 
    end
    total
  end
  
  private
  
  def build_atby(onat,by)
    "on #{onat.strftime('%d/%m/%Y')} at #{onat.strftime('%H:%M')} by #{by.code}"
  end
end
