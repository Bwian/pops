class ApplicationController < ActionController::Base

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
    end
    
    update_timeout
  end
   
  def update_timeout
    session[:timeout] = Time.now.to_i + 600
  end
  
  private

  def authorised_action
    if !view_context.authorised_action params[:action], params[:controller], @order
      redirect_to orders_url, notice: "Action #{params[:action]} not allowed for #{params[:controller]}"
    end
    true
  end
  
  INDEX  = 'index'
  SHOW   = 'show'
  SEARCH = 'search'
  ALL    = 'all'
  NONE   = 'none'

  ADMIN = {
    'orders'        => [ALL],
    'items'         => [ALL],
    'users'         => [INDEX, SHOW],
    'deliveries'    => [INDEX, SHOW],
    'notes'         => [INDEX, SEARCH],
    'suppliers'     => [INDEX],
    'payment_terms' => [INDEX],
    'programs'      => [INDEX],
    'accounts'      => [INDEX],
    'tax_rates'     => [INDEX]
  }

  def admin_action
    if params[:controller] =~ /^tbr/   # TBR authentication handled seperately
      user = User.find(session[:user_id])
      return user.tbr_admin || user.tbr_manager if params[:action] == 'reports'
      return user.tbr_admin
    end
    
    valid_actions = ADMIN[params[:controller]]
    if valid_actions && (valid_actions.include?(ALL) || valid_actions.include?(params[:action]))
      return true
    else
      return session[:admin]
    end
  end
  
  def reload_if_stale(model)
    if model.errors.messages[:locking_error]
      model.reload
      save_json(model.class.name.downcase,model)
    end
  end
end
