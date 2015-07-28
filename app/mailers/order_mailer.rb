class OrderMailer < ActionMailer::Base

  # @order, @from and @to need to be set up for use by the view
  
  before_action :set_defaults
  
  def submitted_email(order,args)
    @order = order
    @to = order.approver
    @from = order.creator
    
    build_mail('submitted')
  end
  
  def approved_email(order,args)
    @order = order
    @to = order.creator
    @from = order.approver
    
    pdf = OrderPdf.new(@order)
    attachments["PO_#{@order.id}.pdf"] = pdf.render
    
    build_mail('approved')
  end
  
  def resubmitted_email(order,args)
    @order = order
    @to = order.approver
    @from = args[:user]
    @body = args[:body]
    
    build_mail('reset to Submitted')
  end
  
  def redrafted_email(order,args)
    @order = order
    @to = order.creator
    @from = args[:user]
    @body = args[:body]
    
    build_mail('reset to Draft')
  end
  
  def changed_email(order,args)
    @order = order
    @to = args[:to]
    @from = args[:user]
    @body = args[:body]

    build_mail('changed')
  end
  
  def reminder_email(order)
    @order = order
    @to = order.creator
    @from = User.new
    @from.email = 'pops.noreply@ucare.org.au'
    
    build_mail('reminder')
  end
  
  def reminder_summary(user,orders)
    @to = user
    @orders = orders
    
    mail(to: @to.email, from: "pops.noreply@ucare.org.au", subject: "Outstanding purchase orders")
  end
  
  private
  
  def build_mail(action)
    mail(to: @to.email, from: @from.email, subject: "Purchase Order #{@order.id} #{action}.")
  end
  
  def set_defaults
    @host = ENV['pops_host']
  end
end
