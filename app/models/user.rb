require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  attr_reader :password
  
  has_many :creators, :class_name => 'User'
  has_many :approvers, :class_name => 'User'
  has_many :processors, :class_name => 'User'
  
  default_scope { order(:name) }

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  validate :filters_valid
  
  @@selection = nil
  
  def self.selection
    @@selection ||= User.where(approver: true).map { |s| [s.name, s.id] }
  end
  
  def save
    @@selection = nil  # force reload
    super
  end
  
  def destroy
    @@selection = nil  # force reload
    super
  end

  def roles
    role_array = [] 
        
    role_array << OrderStatus::PROCESSOR  if self.processor
    role_array << OrderStatus::APPROVER  if self.approver
    role_array << OrderStatus::CREATOR  if self.creator
    
    role_array
  end
  
  def first_name
    self.name.nil? ? '' : self.name.split(" ")[0]
  end
  
  def email_valid?
    return false if self.email.nil?
    return false if self.email.empty?
    true
  end

  private
  
  def filters_valid
    check_filter(:accounts_filter,self.accounts_filter)
    check_filter(:programs_filter,self.programs_filter)
  end
  
  def check_filter(field,filter)
    return if filter.nil? || filter.empty?
    idx = filter =~ /[^0-9, \-]/
    return if idx.nil?
    
    errors.add(field,"contains invalid character '#{filter[idx]}' at position #{idx+1}.  Filters should consist of numbers and ranges separated by spaces or commas.  eg. 1234,2345-3456 4567")
  end
end
