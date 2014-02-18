class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :authorise
  before_filter :timeout
  
  protected

  def authorise    
    session[:return_to] = request.fullpath if request.get?
    unless User.find_by_id(session[:user_id]) && admin_action
      redirect_to login_url, notice: "Please log in to access this feature"
    end
  end

  def timeout
    if session[:timeout] < Time.now.to_i 
      redirect_to login_url, notice: "Session timed out - please log in"
    else
      update_timeout
    end
  end
   
  def update_timeout
    session[:timeout] = Time.now.to_i + 300
  end
  
  private

  def authorised_action
    if !view_context.authorised_action params[:action], params[:controller], @order
      redirect_to orders_url, notice: "Action #{params[:action]} not allowed for #{params[:controller]}"
    end
    true
  end
  
  INDEX = 'index'
  SHOW  = 'show'
  ALL   = 'all'
  NONE  = 'none'

  ADMIN = {
    'orders'    => [ALL],
    'items'     => [ALL],
    'users'     => [INDEX, SHOW],
    'suppliers' => [INDEX],
    'programs'  => [INDEX],
    'accounts'  => [INDEX],
    'tax_rates' => [INDEX]
  }

  def admin_action
    valid_actions = ADMIN[params[:controller]]
    if valid_actions.include?(ALL) || valid_actions.include?(params[:action])
      return true
    else
      return session[:admin]
    end
  end
  
end
