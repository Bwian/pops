class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @readonly = true

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        User.reset_selection
        format.html { redirect_to(users_url, notice: "User #{@user.name} was successfully created.") }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        User.reset_selection
        format.html { redirect_to(users_url, notice: "User #{@user.name} was successfully updated.") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    User.reset_selection

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :code, :password, :hashed_password, :salt, :email, :approver_id, :creator, :approver, :processor, :admin)
  end
end
