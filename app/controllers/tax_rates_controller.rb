class TaxRatesController < ExoController
  
  before_filter :setup

private

  def model_params
    params.require(:tax_rate).permit(:name, :status, :short_name, :rate)
  end

  def setup
    @class  = TaxRate
    @model  = TaxRate.find(params[:id]) if params[:id]
    @models = TaxRate.all
    @models_url = "tax_rates_url"
  end
end
