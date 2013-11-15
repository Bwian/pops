class ProgramsController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @programs }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to(programs_url, notice: "Refresh Programs option not yet implemented") }
      format.xml { head :ok }
    end
  end
end
