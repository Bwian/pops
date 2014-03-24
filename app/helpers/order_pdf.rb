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
    header(order)
    @pdf.text "I installed Adobe Reader and all I got was this lousy printout."
    footer
  end

  def header(order)
  	@pdf.table([
			[{:image => "#{Rails.root}/app/assets/images/logo.jpg", :scale => 0.15}, 
			 {:content => 'Purchase Order', :colspan => 3, :align => :right, :text_color => UCB_GREEN, :size => 20, :font_style => :bold}],
      [{:content => order.supplier_name, :font_style => :bold, :colspan => 2}, 
       {:content => 'PO Number:', :align => :right, :text_color => UCB_RED, :font_style => :bold},
       {:content => order.id.to_s, :text_color => UCB_GREEN, :font_style => :bold, :size => 14 }],
      [{:content => order.supplier.address1, :colspan => 2},
       {:content => 'Date:', :align => :right, :text_color => UCB_RED, :font_style => :bold},
       {:content => format_date(order.approved_at)}],
      [{:content => order.supplier.address2, :colspan => 2},
       {:content => 'Your Ref:', :align => :right, :text_color => UCB_RED, :font_style => :bold},
       {:content => order.reference}],
      [{:content => order.supplier.address3, :colspan => 2},
       {:content => 'Approved by:', :align => :right, :text_color => UCB_RED, :font_style => :bold},
       {:content => order.approver.name}]
		], :column_widths => [130,130,130,130]) do
			cells.padding = 1
			cells.borders = []
      column(3).style(:align => :right)
      # column(1).style(:align => :center)
		end
  end
  
  def footer
  	page_no = '<page> of <total>'
		@pdf.number_pages(page_no, {:at => [0,0], :align => :center})	
  end
  
  def format_date(date)
    date ? "#{date.strftime('%d %b %Y')}" : ''
  end
end