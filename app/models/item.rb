class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :program
  belongs_to :account
  belongs_to :tax_rate
  
  default_scope { order('created_at ASC') }
  
  validates :order_id, 
            :program_id, 
            :account_id, 
            :tax_rate_id, 
            :description, 
            :price, 
            presence: true
  
  def save
    begin
      super
    rescue ActiveRecord::StaleObjectError
      errors.add(:locking_error, "- Item changed by another user")
      return false
    end
  end
            
  def gst
    rate = self.tax_rate_id ? self.tax_rate.rate : 0.0
    p = self.price ? self.price : 0.0
    p * rate.to_f / (100.0 + rate.to_f)
  end
  
  def formatted_gst
    sprintf('%.2f', self.gst)
  end
  
  def subtotal
    price - gst
  end
  
  def formatted_subtotal
    price.nil? ? '' : sprintf('%.2f', self.subtotal)
  end
  
  def formatted_price
    price.nil? ? '' : sprintf('%.2f', self.price)
  end
  
  def program_name
    self.program ? "#{self.program.name} (#{self.program_id})" : "Missing Program #{self.program_id}"
  end
  
  def program_code
    self.program_id.to_s
  end
  
  def account_name
    self.account ? "#{self.account.name} (#{self.account_id})" : "Missing Account #{self.account_id}"
  end  
  
  def tax_rate_name
    self.tax_rate ? self.tax_rate.name : "Missing Tax Rate #{self.tax_rate_id}"
  end
  
  def tax_rate_short_name
    self.tax_rate ? self.tax_rate.short_name : "Missing Tax Rate #{self.tax_rate_id}"
  end
  
  def to_json
    json = self.as_json
    json['price']       = self.formatted_price
    json['program']     = "#{self.program_name} (#{self.program_id})"
    json['account']     = "#{self.account_name} (#{self.account_id})"
    json['tax_rate']     = "#{self.tax_rate_name} (#{self.tax_rate_id})"    
    json.delete('program_id')
    json.delete('account_id')
    json.delete('tax_rate_id')
    json.delete('lock_version')    
    json = json.delete_if { |key,value| key =~ /_at$/ }
    json
  end
end
