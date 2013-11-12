class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])
    @readonly = true

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render xml: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render xml: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(order_params)
    @order.status = OrderStatus::DRAFT
    @order.creator_id = session[:user_id]

    respond_to do |format|
      if @order.save
        format.html { redirect_to(orders_url, notice: "Order #{@order.id} was successfully created.") }
        format.xml { render xml: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(order_params)
        format.html { redirect_to(orders_url, notice: "Order #{@order.id} was successfully updated.") }
        format.xml { head :ok }
      else
        format.html { render action: "edit" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml { head :ok }
    end
  end
  
  private
  
  def order_params
    params.require(:order).permit(
      :supplier_id,
      :supplier_name, 
      :invoice_no, 
      :invoice_date, 
      :payment_date, 
      :reference, 
      :creator_id, 
      :created_at,
      :approver_id,
      :approved_at, 
      :processor_id, 
      :processed_at) 
  end
end
