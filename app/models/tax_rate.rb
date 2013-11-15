class TaxRate < ActiveRecord::Base
  has_many :order_items
  has_many :accounts

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= TaxRate.all.map { |t| [t.name, t.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
end
