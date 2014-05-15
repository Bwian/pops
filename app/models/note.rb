class Note < ActiveRecord::Base
  belongs_to :order 
  belongs_to :user
  
  default_scope { order('created_at DESC') }
  
  validates :order_id,
            :user_id,
            :info,
            presence: true

  def user_name
    self.user ? self.user.name : "Missing User #{self.user_id}"
  end  
end
