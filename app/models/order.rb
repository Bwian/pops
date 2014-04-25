class Order < ActiveRecord::Base
  
  FROM  = 0
  TO    = 1
  ID    = 'id'
  
  belongs_to :supplier
  belongs_to :creator, :class_name => 'User' 
  belongs_to :approver, :class_name => 'User'
  belongs_to :processor, :class_name => 'User'
  has_many :items, :dependent => :destroy
  
  validates :supplier_id, :status, presence: true
  validate :approver_present, :approver_not_processor
  
  before_save :set_supplier
  
  def approver_present
    errors.add(:approver_id, "must be present") if self.approver_id.nil? && self.status == OrderStatus::SUBMITTED
  end
  
  def approver_not_processor
    errors.add(:processor_id, "must not be the same as Approver") if !self.processor_id.nil? && self.approver_id == self.processor_id
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
  
  def supplier_address1
    supplier_address(1)
  end
  
  def supplier_address2
    supplier_address(2)
  end
    
  def supplier_address3
    supplier_address(3)
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
  
  def formatted_gst
    sprintf('%.2f', self.gst)
  end
  
  def formatted_subtotal
    sprintf('%.2f', self.subtotal)
  end
  
  def formatted_grandtotal
    sprintf('%.2f', self.grandtotal)
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
  
  def draft?
    self.status == OrderStatus::DRAFT
  end
  
  def submitted?
    self.status == OrderStatus::SUBMITTED
  end
  
  def approved?
    self.status == OrderStatus::APPROVED
  end
  
  def processed?
    self.status == OrderStatus::PROCESSED
  end
  
  def to_json
    oj = self.as_json(include: [:supplier, {items: {include: [:program, :account, :tax_rate]}}])
    oj["supplier"]        = "#{self.supplier_name} (#{self.supplier_id})"
    oj["invoice_date"]    = build_date(self.invoice_date)
    oj["payment_date"]    = build_date(self.payment_date)
    oj["creator"]         = build_user(self.creator_id)
    oj["approver"]        = build_user(self.approver_id)
    oj["processor"]       = build_user(self.processor_id)
    idx = 0
    oj["items"].each do |item|
      item["price"]       = sprintf('%.2f', item["price"])
      item["program"]     = "#{item['program']['name']} (#{item['program_id']})"
      item["account"]     = "#{item['account']['name']} (#{item['account_id']})"
      item["tax_rate"]    = "#{item['tax_rate']['name']}-#{item['tax_rate']['rate']}% (#{item['program_id']})"
      oj["items"][idx]    = item
      idx += 1
    end

    oj = oj.delete_if { |key,value| key =~ /_at$|id$/ }
    oj.delete("supplier_name")
    oj["items"].each do |item|
      item.each { |key,value| item.delete(key) if key =~ /_at$|_id$/ }
    end 
    oj.update(oj) { |key,value| value.nil? ? '' : value }
    oj
  end
  
  def diff_json(from_order)
    to_order = self.to_json
    return '' if from_order == to_order

    diff = diff_message(from_order,to_order)
    
    from = from_order['items']
    to = to_order['items']
    out = []
    
    from.each do |from_item|
      out << [from_item,nil]
    end

    to.each do |to_item|
      found = nil
      out.each_with_index do |items,idx|
        found = idx if items[FROM] && to_item[ID] == items[FROM][ID]    
      end
      found ? out[found][TO] = to_item : out << [nil,to_item] 
    end

    idx = 1
    out.each do |items|
      if items[TO].nil?
        diff << "Item #{idx} - deleted:\n#{diff_message(items[FROM],items[TO])}"
      elsif items[FROM].nil?
        diff << "Item #{idx} - added:\n#{diff_message(items[FROM],items[TO])}"
      else
        diff << "Item #{idx} - changed:\n#{diff_message(items[FROM],items[TO])}" if items[FROM] != items[TO]
      end
      idx += 1
    end
    
    diff.empty? ? diff : "Changes:\n#{diff}".sub(/\n$/,'')
  end
  
  private
  
  def diff_message(from,to)
    diff = ''
    if from.nil?
      to.each { |key,value| diff << "- #{key}: '#{value}'\n" if key != 'items' }
    elsif to.nil?
      from.each { |key,value| diff << "- #{key}: '#{value}'\n" if key != 'items' }
    else
      from.each { |key,value| diff << "- #{key}: '#{value}' to '#{to[key]}'\n" if  key != 'items' && from[key] != to[key] }
    end
    diff
  end
  
  def build_atby(onat,by)
    "on #{onat.strftime('%d/%m/%Y')} at #{onat.strftime('%H:%M')} by #{by.code}"
  end
  
  def set_supplier
    self.supplier_name = self.supplier.name if self.supplier_id > 0
  end
  
  def build_datetime(date)
    date ? "#{date.strftime('%d %b %Y')} - #{date.strftime('%H:%M')}" : nil
  end
  
  def build_date(date)
    date ? "#{date.strftime('%d %b %Y')}" : nil
  end
  
  def build_user(id)
    id ? User.find(id).code : nil
  end
  
  def supplier_address(line)
    return '' if self.supplier_id && self.supplier_id == 0
    self.supplier.send("address#{line}")
  end
end
