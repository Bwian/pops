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
    ldap_enabled = ENV['ldap_enabled'] && ENV['ldap_enabled'] == 'true'
    unless ldap_enabled
      user = User.find_by_code(login)
      return user
    end
    
    user = nil
    ldap = LdapAgent.new
    
    binding.pry
		if ldap.search(login)
    	if ldap.authenticate(ldap.dn,password)
				user = User.find_by_code(login)
				unless user
					user = User.new
					user.code = login
					user.name  = ldap.name
    			user.email = ldap.email
    			user.phone = ldap.phone
					user.admin = true if User.count == 0
					user.save
				end
			else
        Rails.logger.info("Login for #{login} failed: #{ldap.notice}")
        @alert = ldap.notice unless ldap.notice =~ /49/ # Invalid Credentials
    	end
    else
      Rails.logger.info("Login for #{login} failed: #{ldap.notice}")
      @alert = ldap.notice
    end
    
    user
  end
end
