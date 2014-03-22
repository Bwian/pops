class ProgramsController < ApplicationController
  # GET /users
  def index
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /orders/new
  def new
    respond_to do |format|
      format.html { redirect_to(programs_url, notice: "Refresh Programs option not yet implemented") }
    end
  end
end
