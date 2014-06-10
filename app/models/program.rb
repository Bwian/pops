class Program < ActiveRecord::Base
  
  include Exo
  
  has_many :order_items

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Program.where(status: ['A','N']).map { |p| [p.name, p.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
  
end
