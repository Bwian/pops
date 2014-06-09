class Account < ActiveRecord::Base
  has_many :order_items
  belongs_to :tax_rate 

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Account.where(status: ['A','N']).map { |a| [a.name, a.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
end
