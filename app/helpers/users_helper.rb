module UsersHelper
  def creator(user)
    creator = user.creator ? 'creator' : ''
  end
  
  def approver(user)
    approver = user.approver ? 'approver' : ''
  end
  
  def processor(user)
    processor = user.processor ? 'processor' : ''
  end
  
  def admin(user)
    admin = user.admin ? 'admin' : ''
  end
end
