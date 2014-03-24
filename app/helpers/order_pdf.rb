class OrderPdf
  
	ROW_COLOUR_ODD    = "EBD6D6"
	ROW_COLOUR_EVEN   = "FFFFFF"
	ROW_COLOUR_HEAD   = "D6ADAD"
	UCB_GREEN				  = "666633"
	UCB_RED					  = "993333"
  
  attr_reader :pdf
  
  def initialize(order)
    @pdf = Prawn::Document.new
    build(order)  
  end
  
  def print
    @pdf.print
  end
  
  def render
    @pdf.render
  end
  
  private
  
  def build(order)
    header('Purchase Order', 'Number 123')
    @pdf.text "I installed Adobe Reader and all I got was this lousy printout."
    footer
  end

  def header(heading,name)
  	@pdf.table([
			[{:image => "#{Rails.root}/app/assets/images/logo.jpg", :scale => 0.1, :rowspan => 2}, 
			{:content => heading, :rowspan => 2, :text_color => UCB_GREEN, :size => 20, :font_style => :bold },
			{:content => @invoice_month, :text_color => UCB_RED, :font_style => :bold}],
			[{:content => name, :text_color => UCB_RED, :font_style => :bold}]
		], :column_widths => [130,260,130]) do
			cells.padding = 0
			cells.borders = []
			column(2).style(:align => :right)
			column(1).style(:align => :center)
		end
  end
  
  def footer
  	page_no = '<page> of <total>'
		@pdf.number_pages(page_no, {:at => [0,0], :align => :center})	
  end
  
end