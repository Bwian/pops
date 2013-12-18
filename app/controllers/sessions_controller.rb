class SessionsController < ApplicationController
  
  skip_before_filter :authorise, :timeout

  def new
  end

  def create
    return_to = session[:return_to] ? session[:return_to] : welcome_url
    reset_session
    session[:return_to] = return_to

    if user = User.authenticate(params[:code], params[:password])
      session[:user_id] = user.id
      session[:admin] = user.admin
      session[:role] = user.roles[0]
      update_timeout
      redirect_to session[:return_to]
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to login_url
  end
end
