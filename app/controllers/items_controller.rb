class ItemsController < ApplicationController
  
  include NotesHelper
  
  before_filter :find_item, only: %w[show edit update destroy]
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
    list = [] 
    program_list(@program_item,@program_flag).each do |a|
      list << { text: a[0], value: a[1] }
    end
    respond_to do |format|
      format.json { 
        render json: list.to_json
      } 
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
  
  def program_list(item,flag)
    filter = User.find(session[:user_id]).programs_filter  
    select_list(filter,Program.selection,item.program_id,flag)
  end
  
  def select_list(filter,list,current_id,flag)
    ranges = build_ranges(filter)
    return list if ranges.empty? 
    return list if !flag
    
    current_id = '\\' if current_id.nil?
    filtered_list = []
    list.each do |line|
      ranges.each do |range|
        filtered_list << line if range.cover?(line[1])
      end
      filtered_list << line if !filtered_list.detect {|s| s[1] == current_id } && current_id == line[1]
    end
    filtered_list
  end
  
  def build_ranges(filter)
    ranges = []
    filter = '' if filter.nil?
    
    filter.split(/,| /).each do |f|
      fromto = f.split('-')
      case fromto.size
        when 0
          next
        when 1
          from = fromto[0].to_i
          to = f.last == '-' ? 1.0/0.0 : from
        else
          from = fromto[0].to_i
          to = fromto[1].to_i
      end
      range = from..to
      ranges << range
    end
     
    ranges 
  end
end
