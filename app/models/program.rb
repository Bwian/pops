class Program < ActiveRecord::Base
  
  include Exo
  
  has_many :order_items

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Program.where(status: ['A','N']).map { |p| [p.name_id, p.id] }
  end
  
  def save
    @@selection = nil
    super
  end
end
