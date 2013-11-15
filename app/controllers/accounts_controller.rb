class AccountsController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @accounts }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to(accounts_url, notice: "Refresh Accounts option not yet implemented") }
      format.xml { head :ok }
    end
  end
end
