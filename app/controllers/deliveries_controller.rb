class DeliveriesController < ApplicationController
  before_action :find_delivery, except: %w[index new create]

  # GET /deliveries
  def index
    @deliveries = Delivery.all
  end

  # GET /deliveries/1
  def show
    @readonly = true
  end

  # GET /deliveries/new
  def new
    @delivery = Delivery.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries
  def create
    @delivery = Delivery.new(delivery_params)

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'Delivery was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /deliveries/1
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to @delivery, notice: 'Delivery was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /deliveries/1
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery).permit(:name, :address)
    end
end
