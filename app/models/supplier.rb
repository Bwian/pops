class Supplier < ActiveRecord::Base
  # has_many :orders

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Supplier.all.map { |s| [s.name, s.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
end
