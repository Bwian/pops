class TbrMailer < ActionMailer::Base

  # @order, @from and @to need to be set up for use by the view
  
  before_action :set_defaults
  
  def summary_email(user,manager,filename)
    @from = user
    @to = manager
    @filename = File.basename(filename, '.*')
    attachments["TBR Summary - #{@filename}.pdf"] = File.read(filename)
    
    mail(to: @to.email, from: @from.email, subject: "Telstra Bill Summary - #{@filename}")
  end
  
  private
  
  def set_defaults
    @host = ENV['pops_host']
  end
end
