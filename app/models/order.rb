class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  has_many :items
  
  validates :supplier_id, :status, presence: true
  validate :approver_present
  
  before_save :set_supplier
  
  def approver_present
    errors.add(:approver_id, "must be present") if self.approver_id.nil? && self.status == OrderStatus::SUBMITTED
  end
    
  def status_name
    OrderStatus.status(self.status)
  end
  
  def atby
    notes = [ "created #{build_atby(self.created_at,self.creator)}" ]
    notes << "approved #{build_atby(self.approved_at,self.approver)}" if self.approved_at
    notes << "processed #{build_atby(self.processed_at,self.processor)}" if self.processed_at  
    notes
  end
  
  def supplier_desc
    self.supplier_id && self.supplier_id > 1 ? self.supplier.name : self.supplier_name
  end
  
  def subtotal
    grandtotal - gst
  end
  
  def gst
    total = 0.0
    self.items.each do |item|
      total += item.gst 
    end
    total
  end
  
  def grandtotal
    total = 0.0
    self.items.each do |item|
      total += item.price 
    end
    total
  end
  
  def to_draft
    self.status       = OrderStatus::DRAFT
  end
  
  def to_submitted
    self.approved_at  = nil
    self.status       = OrderStatus::SUBMITTED
  end
  
  def to_approved(user_id) 
    self.approver_id  = user_id if status == OrderStatus::SUBMITTED
    self.approved_at  = Time.now
    self.processor_id = nil
    self.processed_at = nil
    self.status       = OrderStatus::APPROVED
  end
  
  def to_processed(user_id)
    self.processor_id = user_id
    self.processed_at = Time.now
    self.status       = OrderStatus::PROCESSED
  end
  
  private
  
  def build_atby(onat,by)
    "on #{onat.strftime('%d/%m/%Y')} at #{onat.strftime('%H:%M')} by #{by.code}"
  end
  
  def set_supplier
    self.supplier_name = self.supplier.name if self.supplier_id > 0
  end
end
