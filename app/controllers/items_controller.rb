class ItemsController < ApplicationController

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])
    @order = @item.order
    @readonly = true

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render xml: @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new
    @item.order_id = params[:order_id]
    @item.program_id = session[:program_id]
    @item.account_id = session[:account_id]
    @order = @item.order

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render xml: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @order = @item.order
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(item_params)
    @order = @item.order
    session[:program_id] = @item.program_id
    session[:account_id] = @item.account_id
    
    respond_to do |format|
      if @item.save
        format.html { redirect_to(order_url :id => @order.id) }
        format.xml { render xml: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.xml { render xml: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(item_params)
        format.html { redirect_to(order_url(:id => @item.order_id, notice: "Item was successfully updated.")) }
        format.xml { head :ok }
      else
        format.html { render action: "edit" }
        format.xml { render xml: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml { head :ok }
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
  
  private
  
  def item_params
    params.require(:item).permit(
      :order_id,
      :program_id,
      :account_id,
      :tax_rate_id,
      :description,
      :quantity,
      :price
     ) 
  end
end
