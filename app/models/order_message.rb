class OrderMessage
  
  attr_writer :body, :to
  
  def initialize(order,action,user_id)
    @order = order
    @action = action
    @user = User.find(user_id)
    @body = ''
    self.send("#{action}")  # Setup mailer
  end

  def notice
    return "Missing user record for Order #{@order.id}" unless @to && @from
  
    return "Email not sent - no email address for #{@to.name}." unless @to.email_valid?
    return "Email not sent - no email address for #{@from.name}." unless @from.email_valid?
    
    return "Order emailed to #{@to.name} at #{@to.email}"
  end

  def deliver
    mail = OrderMailer.send("#{@action}_email", @order, user: @user, to: @to, body: self.body)
    mail.deliver
  end

  def body
    @body.gsub("\n","</br>").html_safe
  end
  
  def valid?
    return false unless @from && @from.email
    return false unless @to && @to.email
    true  
  end
  
  def from_eq_to?
    @from == @to
  end
  
  private
  
  def approved
    @to = @order.creator
    @from = @order.approver
  end
  
  def resubmitted
    @to = @order.approver
    @from = @user
  end
  
  def redrafted
    @to = @order.creator
    @from = @user
  end
  
  def changed
    @to = @order.creator
    @from = @user
  end
end
