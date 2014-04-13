class OrderMessage

  def initialize(order,action)
    @order = order
    self.send("#{action}")
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
end