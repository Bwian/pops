class TbrService < ActiveRecord::Base
  belongs_to :manager, class_name: 'User'
  belongs_to :user
  
  default_scope { order(:code) }
  validates :code, presence: true
  
  def self.pops_name
    'TBR Service'
  end
  
  def self.service_types
    TbrService.select('distinct service_type').map(&:service_type) 
  end
  
  def self.services
    TbrService.all.map { |s| [s.code, s.manager_code, s.name, s.cost_centre] } 
  end
  
  def self.group(id)
    TbrService.where(manager_id: id).map(&:code)
  end
  
  def manager_code
    self.manager.nil? ? 'Unassigned' : self.manager.code
  end
  
  def user_code
    self.user.nil? ? 'Unassigned' : self.user.code
  end
end
