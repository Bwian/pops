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
    return "Missing user records for Order #{@order.id}" if !(@to && @from)
  
    return "No email address for #{@to.name} - Order #{@order.id}" if !@to.email
    return "No email address for #{@from.name} - Order #{@order.id}" if !@from.email
    
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
    return false if !@from || !@from.email
    return false if !@to || !@to.email
    true  
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
  
  def changed
    @to = nil
    @from = @user
  end
end