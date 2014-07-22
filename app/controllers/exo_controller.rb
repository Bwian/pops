class ExoController < ApplicationController
  
  # GET /users
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /orders/new
  def new
    eu = ExoUpdater.new(@class.name,[])
    respond_to do |format|
      format.html { redirect_to(send(@models_url), notice: eu.notice) }
    end
  end
  
  # GET /users/1
  def show
    @readonly = true

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  def update
    respond_to do |format|
      if @model.update_attributes(model_params)
        @class.reset_selection
        format.html { redirect_to(send(@models_url), notice: "#{@class.name} #{@model.name} was successfully updated.") }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
end
