class PaymentTermsController < ExoController
  
  before_filter :setup

private

  def model_params
    params.require(:program).permit(:name, :factor, :status)
  end

  def setup
    @class  = PaymentTerm
    @model  = PaymentTerm.find(params[:id]) if params[:id]
    @models = PaymentTerm.all
    @models_url = "payment_terms_url"
  end
end
