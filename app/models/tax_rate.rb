class TaxRate < ActiveRecord::Base
  
  CACHE_KEY = "tax_rates.all"
  
  include Exo
  
  after_save :expire_cache
  
  has_many :order_items
  has_many :accounts

  default_scope { order(:name) }
  
  def self.selection
    Rails.cache.fetch(CACHE_KEY) do
      TaxRate.where(status: ['A','N']).map { |s| [s.name_id, s.id] }
    end
  end
  
  def self.limited_selection
    [['GST',32],['No GST',34]]
  end
 
  def expire_cache
    Rails.cache.delete(CACHE_KEY)
  end
  
end
