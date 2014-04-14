class OrderMailer < ActionMailer::Base

  # @order, @from and @to need to be set up for use by the view
  
  def approved_email(order)
    @order = order
    @to = order.creator
    @from = order.approver
    pdf = OrderPdf.new(@order)

    attachments["PO_#{@order.id}.pdf"] = pdf.render
    mail(to: @to.email, from: @from.email, subject: "Purchase Order #{@order.id} approved.")
  end
  
  def resubmitted_email(order,from)
    @order = order
    @to = order.approver
    @from = from

    mail(to: @to.email, from: @from.email, subject: "Purchase Order #{@order.id} reset to Submitted.")
  end
end
