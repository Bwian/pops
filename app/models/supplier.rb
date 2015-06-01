class Supplier < ActiveRecord::Base
  
  CACHE_KEY = "suppliers.all.#{Rails.env}"
  
  include Exo
  
  after_save :expire_cache
  
  belongs_to :tax_rate
  belongs_to :payment_term
  has_many :orders

  default_scope { order(:name) }
  
  def self.selection
    Rails.cache.fetch(CACHE_KEY) do
      Supplier.where(status: ['A','N']).map { |s| [s.name_id, s.id] }
    end
  end
 
  def expire_cache
    Rails.cache.delete(CACHE_KEY)
  end
  
  # Return address as one string with spaces in each line set to &nbsp
  def address
    address = to_nbsp(self.address1)
    address += ', ' + to_nbsp(self.address2) if !self.address2.blank?
    address += ', ' + to_nbsp(self.address3) if !self.address3.blank?
    address.html_safe
  end
  
  private
  
  def to_nbsp(name)
    name.blank? ? '' : name.gsub(/\s+/,'&nbsp;')
  end
end
