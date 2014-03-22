class SuppliersController < ApplicationController
  # GET /users
  def index
    @suppliers = Supplier.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /orders/new
  def new
    respond_to do |format|
      format.html { redirect_to(suppliers_url, notice: "Refresh Suppliers option not yet implemented") }
    end
  end
end
