class Order < ActiveRecord::Base

  belongs_to :supplier
  belongs_to :creator, :foreign_key => :creator, :class_name => 'User'
  belongs_to :approver, :foreign_key => :approver, :class_name => 'User'
  belongs_to :processor, :foreign_key => :processor, :class_name => 'User'
end
