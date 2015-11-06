class OrderMessage
  
  attr_writer :body, :to
  
  def initialize(order,action,user_id)
    @order = order
    @action = action
    @user = User.find(user_id)
    @body = ''
    @mailer_running = true
    self.send("#{action}")  # Setup mailer
  end

  def notice
    return "Warning! Mail service not running - no mail sent" unless @mailer_running
    
    return "Missing user record for Order #{@order.id}" unless @to && @from
  
    return "Email not sent - no email address for #{@to.name}." unless @to.email_valid?
    return "Email not sent - no email address for #{@from.name}." unless @from.email_valid?
    
    return "Order emailed to #{@to.name} at #{@to.email}"
  end

  def deliver
    mail = OrderMailer.send("#{@action}_email", @order, user: @user, to: @to, body: self.body)
    @mailer_running = true
    begin
      mail.deliver
    rescue Errno::ECONNREFUSED
      @mailer_running = false
    end
  end

  def body
    @body.gsub("\n","</br>").html_safe
  end
  
  def valid?
    return false unless @from && @from.email.present?
    return false unless @to && @to.email.present?
    true  
  end
  
  def from_eq_to?
    @from == @to
  end
  
  private
  
  def submitted
    @to = @order.approver
    @from = @order.creator
  end
  
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
