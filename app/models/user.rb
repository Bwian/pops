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
        
    role_array << 'Processor' if processor
    role_array << 'Approver' if approver
    role_array << 'Creator' if creator
    
    role_array
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
    errors.add(:password, "Missing password") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
