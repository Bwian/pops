class TaxRate < ActiveRecord::Base
  
  include Exo
  
  has_many :order_items
  has_many :accounts

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.limited_selection
    [['GST',32],['No GST',34]]
  end
  
  def self.selection
    @@selection ||= TaxRate.where(status: ['A','N']).map { |t| [t.name, t.id] }
  end
  
  def save
    @@selection = nil
    super
  end
end
