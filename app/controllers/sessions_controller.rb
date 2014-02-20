class SessionsController < ApplicationController
  
  skip_before_filter :authorise, :timeout
  
  def new
  end

  def create
    return_to = session[:return_to] ? session[:return_to] : orders_url
    reset_session
    session[:return_to] = return_to

    if user = User.authenticate(params[:code], params[:password])
      session[:user_id] = user.id
      session[:admin] = user.admin
      session[:order_filter] = OrderFilter.new(user.id)
      update_timeout
      redirect_to return_to
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to login_url
  end
end
