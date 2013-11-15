class TaxRatesController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @tax_rates = TaxRate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @tax_rates }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to(tax_rates_url, notice: "Refresh Tax Rates option not yet implemented") }
      format.xml { head :ok }
    end
  end
end
