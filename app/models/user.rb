require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  attr_reader :password
  
  has_many :creators, :class_name => 'User'
  has_many :approvers, :class_name => 'User'
  has_many :processors, :class_name => 'User'
  
  default_scope { order(:name) }

# TODO: should also be validating presence of :admin but fails unit test
  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  validates :password, confirmation: true
  validate :password_must_be_present

  @@selection = nil
  
  def self.selection
    @@selection ||= User.where(approver: true).map { |s| [s.name, s.id] }
  end
  
  def self.reset_selection
    @@selection = nil  # force reload
  end
  
  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
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
  
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "pops" + salt)
  end

  def User.authenticate(code, password)
    if user = find_by_code(code)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  private

  def password_must_be_present
    errors.add(:password, "Missing password") unless self.hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
