class PaymentTerm < ActiveRecord::Base
  include Exo
  
  has_many :suppliers
end
