class OrderFilter  
  attr_accessor :role, :draft, :submitted, :approved, :processed
  
  def initialize(params)
    update(params)
  end
  
  def update(params)
    return if !params
    @role      = params[:role]
    @draft     = params[:draft]
    @submitted = params[:submitted]
    @approved  = params[:approved]
    @processed = params[:processed]
  end
end