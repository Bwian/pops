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
			user = find_or_create_user(login)	
		else
      @alert = ldap.notice
    end
    
    user
  end
 
	def find_or_create_user(code)
		user = User.find_by_code(code)
		
		unless user
			ldap = LdapAgent.new
			ldap_params = ldap.search(code)
			unless ldap_params == {}
				user = User.new
				user.code = code
				user.name  = set_ldap(ldap_params[:name])
    		user.email = set_ldap(ldap_params[:mail])
    		user.phone = set_ldap(ldap_params[:telephonenumber])
				user.admin = true if User.count == 0
				user.save
			end
		end	
		user
	end 

	def set_ldap(param)
    return '' if param.nil? || param.size == 0
    param.first
  end

end
