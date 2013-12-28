class OrderFilter  
  attr_accessor :role, :draft, :submitted, :approved, :processed, :faults
  
  def initialize(user_id)
    user = User.find(user_id)
    @role = user.roles.size > 0 ? user.roles[0] : OrderStatus::CREATOR 
    @faults = []
    default_filters
  end
  
  def update(params)
    return if !params
    @faults = []
    if params[:role] && @role != params[:role]
      @role      = params[:role]
      default_filters
    else
      @role      = params[:role]
      @draft     = params[:draft]
      @submitted = params[:submitted]
      @approved  = params[:approved]
      @processed = params[:processed]
    end
    
    @faults << 'At least one status filter must be set' unless status_filters_set
  end
  
  def draft?
    !(@draft.nil? || @draft == '0')
  end
  
  def submitted?
    !(@submitted.nil? || @submitted == '0')
  end
  
  def approved?
    !(@approved.nil? || @approved == '0')
  end
  
  def processed?
    !(@processed.nil? || @processed == '0')
  end
  
  private
  
  def status_filters_set
    draft? || submitted? || approved? || processed?
  end
  
  def default_filters
    case @role   
      when OrderStatus::APPROVER 
        @draft     = '0'
        @submitted = '1'
        @approved  = '0'
        @processed = '0'
      when OrderStatus::PROCESSOR 
        @draft     = '0'
        @submitted = '0'
        @approved  = '1'
        @processed = '0'
      else
        @role      = OrderStatus::CREATOR
        @draft     = '1'
        @submitted = '1'
        @approved  = '0'
        @processed = '0'
    end
  end
end