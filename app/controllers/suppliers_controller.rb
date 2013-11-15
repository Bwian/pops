class SuppliersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @suppliers = Supplier.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @suppliers }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to(suppliers_url, notice: "Refresh Suppliers option not yet implemented") }
      format.xml { head :ok }
    end
  end
end
