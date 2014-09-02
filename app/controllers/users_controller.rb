class UsersController < ApplicationController
  
  before_filter :find_user, except: %w[index new create ldap]
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @readonly = true
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_url, notice: "User #{@user.name} was successfully created.") }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /users/1
  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(users_url, notice: "User #{@user.name} was successfully updated.") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end
  
  # PUT /users/1/ldap
  def ldap
    @user = params[:id].nil? ? User.new(user_params) : @user.update_attributes(user_params)
    ldap = LdapAgent.new
    ldap_params = ldap.search(@user.code)
    flash.notice = "Warning! Login details for '#{@user.code}' not found." if ldap_params.empty?
    
    @user.name  = set_ldap(ldap_params[:name])
    @user.email = set_ldap(ldap_params[:mail])
    @user.phone = set_ldap(ldap_params[:telephonenumber])
    
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :code, :email, :phone, :accounts_filter, :programs_filter, :approver_id, :creator, :approver, :processor, :admin)
  end
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def set_ldap(param)
    return '' if param.nil? || param.size == 0
    param.first
  end
end
