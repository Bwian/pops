class AccountsController < ExoController
  
  before_filter :setup

private

  def model_params
    params.require(:account).permit(:name, :status, :short_name, :rate)
  end

  def setup
    @class  = Account
    @model  = Account.find(params[:id]) if params[:id]
    @models = Account.all
    @models_url = "accounts_url"
  end
end