class OrdersController < ApplicationController

  include NotesHelper
  
  before_filter :find_order, except: %w[index new create refresh search payment_date delivery]
  before_filter :authorised_action, only: %w[new edit]
  
  # GET /orders
  def index
    @order_filter = session[:order_filter] || OrderFilter.new(session[:user_id])
    if @order_filter.faults.any?
      @orders = Order.none
    else
      @orders = Order.where(where_parameters)
      @orders = @orders.joins(join_user(params[:sort]))
      @orders = @orders.order(sort_order(params[:sort]))
      params.delete('sort')  # otherwise paginate will save the sort parameter
      @orders = @orders.paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /orders/1
  def show
    @readonly = true
    save_json('order',@order)
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.approver_id = User.find(session[:user_id]).approver_id
  end

  # GET /orders/1/edit
  def edit
  end
  
  def search
    if Order.exists?(params[:id])
      @order = Order.find(params[:id])
      url = order_url
    else
      url = orders_url
      flash.alert = "Could not find order #{params[:id]}"
    end

    respond_to do |format|  
      format.js { render :js => "window.location = '#{url}'" }
    end
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.status = OrderStatus::DRAFT
    @order.creator_id = session[:user_id]

    user = User.find(session[:user_id])
    if user && !user.approver_id && @order.approver_id
      user.approver_id = @order.approver_id
      user.save
    end
    
    respond_to do |format|
      if @order.save
        params[:id] = @order.id
        save_user_notes(params)
        format.html { redirect_to new_order_item_path(@order) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH /orders/1
  def update
    respond_to do |format|
      if @order.update_attributes(order_params)
        add_notes('order',@order)
        save_user_notes(params)
        if params[:order_notes]
          message = @order.sendmail(session[:user_id])
          message.deliver if message && message.valid?
        end
        format.html { redirect_to(@order, notice: "Order #{@order.id} was successfully updated. #{get_notice(message)}") }
      else
        reload_if_stale(@order)
        format.html { render :edit }
      end
    end
  end

  # DELETE /orders/1
  def destroy
    add_notes('order',nil)
    @order.destroy

    respond_to do |format|
      if @order.destroyed?
        format.html { redirect_to(orders_url,notice: "Order #{@order.id} was successfully deleted.") }
      else
        format.html { render :show }
      end
    end
  end
  
  # POST /orders/1/draft
  def redraft
    @order.to_draft
    add_notes('order',@order)
    save_user_notes(params)
    message = @order.sendmail(session[:user_id])  
    
    respond_to do |format|
      if @order.save   
        url = @order.creator_id == session[:user_id] ? order_url : orders_url
        flash.notice = "Order #{@order.id} reset to Draft. #{get_notice(message)}"
        format.js { render :js => "window.location = '#{url}'" }
        message.deliver if message && message.valid?
      else
        find_order
        format.js { render :edit }
      end
    end
  end
  
  # POST /orders/1/submit
  def submit
    @order.to_submitted
    add_notes('order',@order) if @order.notes.any?
    message = @order.sendmail(session[:user_id])

    respond_to do |format|
      if @order.save
        save_user_notes(params)
        format.html { redirect_to(@order, notice: "Order #{@order.id} set to Submitted.") }
        message.deliver if message && message.valid?
      else
        @order.to_draft
        @readonly = true
        format.html { render :show }
      end
    end
  end
  
  def resubmit
    @order.to_submitted
    add_notes('order',@order)
    save_user_notes(params)
    message = @order.sendmail(session[:user_id])

    respond_to do |format|
      if @order.save
        url = @order.creator_id == session[:user_id] || @order.approver_id == session[:user_id] ? order_url : orders_url
        flash.notice = "Order #{@order.id} reset to Submitted. #{get_notice(message)}"
        format.js { render :js => "window.location = '#{url}'" }
        message.deliver if message && message.valid?
      else
        find_order
        format.js { render :edit }
      end
    end
  end
  
  # POST /orders/1/approve
  def approve
    @order.to_approved(session[:user_id])
    add_notes('order',@order) if @order.notes.any?
    message = @order.sendmail(session[:user_id])
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to(@order, notice: "Order #{@order.id} set to Approved. #{get_notice(message)}") }
        message.deliver if message && message.valid?
      else
        @order.to_submitted
        @readonly = true
        format.html { render :show }
      end
    end
  end
  
  # POST /orders/1/complete
  def complete
    agent = ExoAgent.new
    @order.to_processed(session[:user_id])
    completed = true
    if @order.valid? && !agent.complete(@order)
      @order.errors.add(:processing_failed," - #{agent.notice}")
      save_notes(@order.id,"Processing failed - #{agent.notice}")
      completed = false
    else
      completed = @order.save
    end
    
    respond_to do |format|
      if completed
        format.html { redirect_to(orders_url, notice: "Order #{@order.id} set to Processed.") }
      else
        @order.reset_approved
        @readonly = true
        format.html { render :show }
      end
    end
  end
  
  # POST /orders/refresh
  def refresh
    order_filter = session[:order_filter] || OrderFilter.new(session[:user_id])
    order_filter.update(params[:order_filter])
    session[:order_filter] = order_filter

    respond_to do |format|
      format.html { redirect_to(orders_url) }
    end
  end
  
  # GET /orders/1/print
  def print
    pdf = OrderPdf.new(@order)
    pdf.print
    
    send_data(pdf.render, 
      filename: "order_#{@order.id}.pdf", 
      type: "application/pdf", 
      disposition: "inline")
  end
  
  def payment_date
    @order = Order.new(order_params)
    @order.set_payment_date
    respond_to do |format|
      format.js
    end
  end
  
  def delivery
    @delivery = params[:delivery_id].empty? ? Delivery.new : Delivery.find(params[:delivery_id])
    respond_to do |format|
      format.js
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
      :processed_at,
      :delivery_address,
      :notes,
      :lock_version) 
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
    
    filter_array.size > 0 ? { status: filter_array } : {}
  end
  
  def join_user(column)
    id_column?(column) ? "LEFT OUTER JOIN users ON users.id = orders.#{column}" : ""
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
    
    sort_by = id_column?(column) ? 'users.name' : session[:sort_by]
    "#{sort_by} #{session[:sort_order]}, created_at desc"
  end
  
  def id_column?(column)
    return false if column.nil?
    column =~ /_id$/
  end
  
  def find_order
    @order = Order.find(params[:id])
  end
  
  def get_notice(message)
    message ? message.notice : ''
  end
  
end
