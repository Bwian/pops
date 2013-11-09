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
  
  # Return address as one string with spaces in each line set to &nbsp
  def address
    address = to_nbsp(address1)
    address += ', ' + to_nbsp(address2) if !address2.blank?
    address += ', ' + to_nbsp(address3) if !address3.blank?
    address.html_safe
  end
  
  private
  
  def to_nbsp(name)
    name.blank? ? '' : name.gsub(/\s+/,'&nbsp;')
  end
end
