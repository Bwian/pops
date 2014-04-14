class OrderMessage

  def initialize(order,action,user_id)
    @order = order
    @user = User.find(user_id)
    self.send("#{action}")  # Setup mailer
  end

  def notice
    return "Missing user records for Order #{@order.id}" if !(@to && @from)
  
    return "No email address for #{@to.name} - Order #{@order.id}" if !@to.email
    return "No email address for #{@from.name} - Order #{@order.id}" if !@from.email
    
    return "Order emailed to #{@to.name} at #{@to.email}"
  end

  def deliver
    @mail.deliver
  end

  private
  
  def approved
    @mail = OrderMailer.approved_email(@order)
    @to = @order.creator
    @from = @order.approver
  end
  
  def resubmitted
    @mail = OrderMailer.resubmitted_email(@order,@user)
    @to = @order.approver
    @from = @user
  end
end