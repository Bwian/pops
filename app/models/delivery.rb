class Delivery < ActiveRecord::Base
  default_scope { order(:name) }
  
  @@selection = nil
  
  def self.selection
    @@selection ||= Delivery.all.map { |p| [p.name, p.id] }
  end
  
  def save
    @@selection = nil
    super
  end
end
