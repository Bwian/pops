class ItemsController < ApplicationController
  
  include NotesHelper
  
  before_filter :find_item, except: %w[index new create gst]
  before_filter :find_order, only: %w[new]
  before_filter :authorised_action, only: %w[new edit]
  
  # GET /items/1
  def show  
    @readonly = true
    save_json('item',@item)
  end

  # GET /items/new
  def new
    save_json('item',nil)
    @item = Item.new
    @item.order_id = params[:order_id]
    @item.program_id = session[:program_id]
    @item.account_id = session[:account_id]
    @order = @item.order
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @order = @item.order
    session[:program_id] = @item.program_id
    session[:account_id] = @item.account_id
    
    respond_to do |format|
      if @item.save
        add_notes('item',@item)
        format.html { redirect_to(order_url :id => @order.id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /items/1
  def update
    respond_to do |format|
      if @item.update_attributes(item_params)
        add_notes('item',@item)
        format.html { redirect_to(order_url(:id => @item.order_id, notice: "Item was successfully updated.")) }
      else
        reload_if_stale(@item)
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /items/1
  def destroy
    add_notes('item',nil)
    @item.destroy
    respond_to do |format|
      format.html { redirect_to(order_url(:id => @item.order_id, notice: "Item was successfully deleted.")) }
    end
  end
  
  def gst
    @gst_item = Item.new(item_params)
    respond_to do |format|
      format.js
    end
  end
  
  def tax_rate
    @tax_item = Item.new(item_params)
    @tax_item.tax_rate_id = nil
    respond_to do |format|
      format.js
    end
  end
  
  def account_select   
    @account_item = Item.new(item_params)
    @account_flag = params[:account_flag]
    respond_to do |format|
      format.js
    end
  end
  
  def program_select
    @program_item = Item.new(item_params)
    @program_flag = params[:program_flag]
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def item_params
    params.require(:item).permit(
      :order_id,
      :program_id,
      :account_id,
      :tax_rate_id,
      :description,
      :quantity,
      :price,
      :lock_version
     ) 
  end
  
  def find_item
    @item = Item.find(params[:id])
    @order = @item.order
  end
  
  def find_order
    @order = Order.find(params[:order_id])
  end
end
