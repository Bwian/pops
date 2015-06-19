module TbrHelper
  
  def show_tbr
    return false unless session[:user_id]
    
    user = User.find(session[:user_id])
    user.tbr_admin || user.tbr_manager
  end
  
  def tbr_admin
    return false unless session[:user_id]
    User.find(session[:user_id]).tbr_admin
  end
  
  def tbr_manager
    return false unless session[:user_id]
    User.find(session[:user_id]).tbr_manager
  end
    
  def link_logs
    link_to("Previous Logs", url_for(action: 'log'), class: ApplicationHelper::LINK_STYLE)
  end
  
end
