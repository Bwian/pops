class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  has_many :items
  
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
  
  def supplier_desc
    supplier_id && supplier_id > 1 ? supplier.name : supplier_name
  end
  
  def subtotal
    total = 0.0
    items.each do |item|
      total += item.subtotal 
    end
    total
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
      total += item.total 
    end
    total
  end
  
  private
  
  def build_atby(onat,by)
    "on #{onat.strftime('%d/%m/%Y')} at #{onat.strftime('%H:%M')} by #{by.code}"
  end
end
