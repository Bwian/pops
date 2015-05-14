class TbrServicesController < ApplicationController
  
  before_action :set_tbr_service, only: [:show, :edit, :update, :destroy]

  # GET /tbr_services
  def index
    @tbr_services = TbrService.all
  end

  # GET /tbr_services/1
  def show
    @readonly = true
  end

  # GET /tbr_services/new
  def new
    @tbr_service = TbrService.new
  end

  # GET /tbr_services/1/edit
  def edit
  end

  # POST /tbr_services
  def create
    @tbr_service = TbrService.new(tbr_service_params)

    respond_to do |format|
      if @tbr_service.save
        format.html { redirect_to @tbr_service, notice: 'Tbr service was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /tbr_services/1
  def update
    respond_to do |format|
      if @tbr_service.update(tbr_service_params)
        format.html { redirect_to @tbr_service, notice: 'Tbr service was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /tbr_services/1
  def destroy
    @tbr_service.destroy
    respond_to do |format|
      format.html { redirect_to tbr_services_url }
    end
  end

  private

    def set_tbr_service
      @tbr_service = TbrService.find(params[:id])
    end

    def tbr_service_params
      params[:tbr_service]
      params.require(:tbr_service).permit(
        :manager_id,
        :user_id,
        :code,:name,
        :cost_centre,
        :rental,
        :service_type,
        :comment,
        :beast
      )
    end
end
