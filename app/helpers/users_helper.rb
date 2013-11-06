module UsersHelper
  def admin(user)
    admin = user.admin ? 'admin' : ''
  end
end
