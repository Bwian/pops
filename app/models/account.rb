class Account < ActiveRecord::Base
  
  CACHE_KEY = "accounts.all"
  
  include Exo
  
  after_save :expire_cache
  
  has_many :order_items
  belongs_to :tax_rate 

  default_scope { order(:name) }
  
  def self.selection
    Rails.cache.fetch(CACHE_KEY) do
      Account.where(status: ['A','N']).map { |s| [s.name_id, s.id] }
    end
  end
 
  def expire_cache
    Rails.cache.delete(CACHE_KEY)
  end
  
end
