class AccountsController < ApplicationController
  # GET /users
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /orders/new
  def new
    respond_to do |format|
      format.html { redirect_to(accounts_url, notice: "Refresh Accounts option not yet implemented") }
    end
  end
end
