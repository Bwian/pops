require 'digest/sha2'

class User < ActiveRecord::Base
  
  CACHE_KEY = "users.all.#{Rails.env}"
  
  after_save :expire_cache
  
  attr_accessor :password_confirmation
  attr_reader :password
  
  has_many :creators, :class_name => 'User'
  has_many :approvers, :class_name => 'User'
  has_many :processors, :class_name => 'User'
  
  default_scope { order(:name) }

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  validate :filters_valid
  
  def self.approvers
    Rails.cache.fetch("approvers.all") do
      User.where(approver: true).map { |s| [s.name, s.id] }
    end
  end

  def self.tbr_managers
    Rails.cache.fetch("tbr_managers.all") do
      User.where(tbr_manager: true).map { |s| [s.name, s.id] }
    end
  end
  
  def self.users
    Rails.cache.fetch(CACHE_KEY) do
      User.all.map { |s| [s.name, s.id] }
    end
  end
  
  def expire_cache
    Rails.cache.delete('approvers.all')
    Rails.cache.delete('tbr_managers.all')
    Rails.cache.delete(CACHE_KEY)
    return true  # needed so that the callback chain continues
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
