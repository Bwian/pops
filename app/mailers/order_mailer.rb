class OrderMailer < ActionMailer::Base

  def approved_email(order)
    @order = order
    @to = @order.creator
    @from = @order.approver
    pdf = OrderPdf.new(@order)

    attachments["PO_#{@order.id}.pdf"] = pdf.render
    mail(to: @to.email, from: @from.email, subject: "Purchase Order #{@order.id} approved.")
  end
end
