class TaxRatesController < ApplicationController
  # GET /users
  def index
    @tax_rates = TaxRate.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /orders/new
  def new
    respond_to do |format|
      format.html { redirect_to(tax_rates_url, notice: "Refresh Tax Rates option not yet implemented") }
    end
  end
end
