class PaymentTerm < ActiveRecord::Base
  
  CACHE_KEY = "payment_terms.all"
  
  include Exo
  
  after_save :expire_cache
  
  has_many :suppliers

  default_scope { order(:name) }
  
  def self.selection
    Rails.cache.fetch(CACHE_KEY) do
      PaymentTerm.where(status: ['A','N']).map { |s| [s.name_id, s.id] }
    end
  end
 
  def expire_cache
    Rails.cache.delete(CACHE_KEY)
  end
  
end
