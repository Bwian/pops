class Program < ActiveRecord::Base
  
  has_many :order_items

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Program.all.map { |p| [p.name, p.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
  
end
