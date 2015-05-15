class Program < ActiveRecord::Base
  
  CACHE_KEY = "programs.all"
  
  include Exo
  
  after_save :expire_cache
  
  has_many :order_items

  default_scope { order(:name) }
  
  def self.selection
    Rails.cache.fetch(CACHE_KEY) do
      Program.where(status: ['A','N']).map { |s| [s.name_id, s.id] }
    end
  end
 
  def expire_cache
    Rails.cache.delete(CACHE_KEY)
  end

end
