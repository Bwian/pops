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
  
end
