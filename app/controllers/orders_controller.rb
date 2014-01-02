class OrdersController < ApplicationController

  # GET /orders
  # GET /orders.xml
  def index
    @order_filter = session[:order_filter] || OrderFilter.new(session[:user_id])
    @orders = @order_filter.faults.any? ? [] : Order.where(where_parameters).order(sort_order(params[:sort]))
    
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
    @order.approver_id = User.find(session[:user_id]).approver_id

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
  
  def draft
    @order = Order.find(params[:id])
    @order.status = OrderStatus::DRAFT
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to(@order, notice: "Order #{@order.id} set to Draft.") }
        format.xml { head :ok }
      else
        format.html { render action: "edit" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def submit
    @order = Order.find(params[:id])
    @order.status = OrderStatus::SUBMITTED
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to(orders_url, notice: "Order #{@order.id} set to Submitted.") }
        format.xml { head :ok }
      else
        @order.status = OrderStatus::DRAFT
        format.html { render action: "edit" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def approve
    @order = Order.find(params[:id])
    @order.status = OrderStatus::APPROVED
    @order.approver_id = session[:user_id]
    @order.approved_at = Time.now
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to(orders_url, notice: "Order #{@order.id} set to Approved.") }
        format.xml { head :ok }
      else
        @order.status = OrderStatus::SUBMITTED
        @order.approver_id = nil
        @order.approved_at = nil
        format.html { render action: "edit" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def complete
    @order = Order.find(params[:id])
    @order.status = OrderStatus::PROCESSED
    @order.processor_id = session[:user_id]
    @order.processed_at = Time.now
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to(@order, notice: "Order #{@order.id} set to Processed.") }
        format.xml { head :ok }
      else
        @order.status = OrderStatus::APPROVED
        @order.processor_id = nil
        @order.processed_at = nil
        format.html { render action: "edit" }
        format.xml { render xml: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def refresh
    order_filter = session[:order_filter] || OrderFilter.new(session[:user_id])
    order_filter.update(params[:order_filter])
    session[:order_filter] = order_filter

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
  
  def where_parameters
    case @order_filter.role   
      when OrderStatus::APPROVER 
        where = { approver_id: session[:user_id] }
        where.merge(filters)
      when OrderStatus::PROCESSOR 
        where = filters
      else
        where = { creator_id: session[:user_id] }
        where.merge(filters)
    end
  end
  
  def filters
    filter_array = []
    filter_array << OrderStatus::DRAFT if @order_filter.draft?
    filter_array << OrderStatus::SUBMITTED if @order_filter.submitted?
    filter_array << OrderStatus::APPROVED if @order_filter.approved?
    filter_array << OrderStatus::PROCESSED if @order_filter.processed?
    
    filter_array.size > 0 ? { status: filter_array} : {}
  end
  
  def sort_order(column)
    if session[:sort_by].nil? || session[:sort_by].empty?
      session[:sort_by]    = 'id'
      session[:sort_order] = 'desc'
    end

    unless column.nil? || column.empty?
      if session[:sort_by] == column
        session[:sort_order] = session[:sort_order] == 'asc' ? 'desc' : 'asc'
      else
        session[:sort_by]    = column
        session[:sort_order] = 'asc'
      end
    end
    
    "#{session[:sort_by]} #{session[:sort_order]}"
  end

end
