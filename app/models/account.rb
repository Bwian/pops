class Account < ActiveRecord::Base
  
  include Exo
  
  has_many :order_items
  belongs_to :tax_rate 

  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Account.where(status: ['A','N']).map { |a| [a.name_id, a.id] }
  end
  
  def save
    @@selection = nil
    super
  end
end
