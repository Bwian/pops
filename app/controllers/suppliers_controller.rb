class SuppliersController < ExoController
  
  before_filter :setup

private

  def model_params
    params.require(:supplier).permit(:name, :address1, :address2, :address3, :phone, :fax, :email, :tax_rate_id, :payment_term_id, :status)
  end

  def setup
    @class  = Supplier
    @model  = Supplier.find(params[:id]) if params[:id]
    @models = Supplier.all
    @models_url = "suppliers_url"
  end
end
