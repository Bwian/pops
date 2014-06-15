class PaymentTerm < ActiveRecord::Base
  include Exo
  
  has_many :suppliers
  
  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= PaymentTerm.where(status: ['A','N']).map { |p| [p.name, p.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
end
