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
    details(order)
    footer
  end

  def header(order)
  	@pdf.table([
			[{:image => "#{Rails.root}/app/assets/images/logo.jpg", :scale => 0.15}, 
			 {:content => 'Purchase Order', :colspan => 3, :align => :right, :text_color => UCB_GREEN, :size => 20, :font_style => :bold}]
		], :position => :right, :column_widths => [130,130,130,130]) do
			cells.padding = 1
			cells.borders = []
      column(3).style(:align => :right)
      # column(1).style(:align => :center)
		end
    
    @pdf.move_down(25)
  	@pdf.table([
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
		], :position => :right, :column_widths => [130,130,130,130]) do
			cells.padding = 1
			cells.borders = []
      column(3).style(:align => :right)
		end
    
    @pdf.move_down(25)
  end
  
  def details(order)
    data = [['Description','Cost']]
    order.items.each do |item|
      data << [item.description,sprintf('%.2f', item.subtotal)]
    end
		
    @pdf.table(data, 
			:position => :right,
      :row_colors => [ROW_COLOUR_EVEN, ROW_COLOUR_ODD],
			:header => :true, 
			:column_widths => [390,130]) do
			cells.padding = [2,5,2,5]
			cells.borders = []
			row(0).font_style = :bold
			row(0).background_color = ROW_COLOUR_HEAD
      column(1).style(:align => :right)
		end
    
    @pdf.move_down(10)
    data = [
      ['Subtotal:',sprintf('%.2f', order.subtotal)],
      ['GST:',sprintf('%.2f', order.gst)],
      ['Total:',sprintf('%.2f', order.grandtotal)]
    ]
    @pdf.table(data, 
			:position => :right,
      :row_colors => [ROW_COLOUR_EVEN, ROW_COLOUR_ODD],
			:header => :true, 
			:column_widths => [130,130]) do
			cells.padding = [2,5,2,5]
			cells.borders = []
			
      row(0).background_color = ROW_COLOUR_ODD
      row(2).font_style = :bold
			row(2).background_color = ROW_COLOUR_HEAD
      column(0).style(:align => :right)
      column(1).style(:align => :right)
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