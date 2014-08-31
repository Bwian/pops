class SessionsController < ApplicationController
  
  skip_before_filter :authorise, :timeout
  
  def new
  end

  def create
    return_to = session[:return_to] ? session[:return_to] : orders_url
    reset_session
    session[:return_to] = return_to
    @notice = ''
    @alert = 'Invalid user/password combination'
    
    if user = authenticate(params[:code], params[:password])
      session[:user_id] = user.id
      session[:admin] = user.admin
      session[:order_filter] = OrderFilter.new(user.id)
      update_timeout
      redirect_to return_to, notice: @notice
    else
      redirect_to login_url, alert: @alert
    end
  end

  def destroy
    reset_session
    redirect_to login_url
  end
  
  private
  
  def authenticate(login,password)
    ldap = LdapAgent.new
    user = nil
    
    if ldap.authenticate(login,password)
      user = User.find_by_code(login) || User.find_by_code('guest')       
      @notice = "No POPS user set up for #{login}.  You have been logged in as a guest with restricted access" if user && user.code == 'guest' 
    elsif Rails.env.production?       
      @alert = ldap.notice
    else
      user = User.find_by_code(login)
    end
    
    user
  end
  
end
