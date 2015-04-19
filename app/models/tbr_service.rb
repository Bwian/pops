class TbrService < ActiveRecord::Base
  belongs_to :manager, class_name: 'User'
  belongs_to :user
  
  def self.pops_name
    'TBR Service'
  end
  
  def manager_code
    self.manager.nil? ? 'Unassigned' : self.manager.code
  end
  
  def user_code
    self.user.nil? ? 'Unassigned' : self.user.code
  end
end
