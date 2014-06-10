class ProgramsController < ExoController
  
  before_filter :setup

private

  def model_params
    params.require(:program).permit(:name, :status)
  end

  def setup
    @class  = Program
    @model  = Program.find(params[:id]) if params[:id]
    @models = Program.all
    @models_url = "programs_url"
  end
end
