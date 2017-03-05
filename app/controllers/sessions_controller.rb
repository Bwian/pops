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
      set_eops
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
  
  def set_eops
    agent = ExoAgent.new
    
    row_start = agent.select("select min(STARTDATE) as SD from [PERIOD_STATUS] where LEDGER = 'C' and LOCKED = 'N'",{ SD: :start_date })
    row_end = agent.select("select max(STOPDATE) as ED from [PERIOD_STATUS] where LEDGER = 'C' and LOCKED = 'N'",{ ED: :end_date })
    
    if (row_start.present? && row_end.present?)
      session[:period_start] = row_start[0][:start_date].to_date
      session[:period_end] = row_end[0][:end_date].to_date
      @notice += "Open period set from EXO to #{session[:period_start].strftime('%d %b %Y')} to #{session[:period_end].strftime('%d %b %Y')}. "
    else
      session[:period_start] = Date.today.day <10 ? Date.today.beginning_of_month - 1.month : Date.today.beginning_of_month
      session[:period_end] = Date.today.end_of_month 
      @notice += "Unable to access EXO.  Open period set to #{session[:period_start].strftime('%d %b %Y')} to #{session[:period_end].strftime('%d %b %Y')}. "
    end
  end
end
