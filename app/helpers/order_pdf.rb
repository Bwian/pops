class OrderPdf
  
	ROW_COLOUR_ODD    = "EBD6D6"
	ROW_COLOUR_EVEN   = "FFFFFF"
	ROW_COLOUR_HEAD   = "D6ADAD"
	UCB_GREEN				  = "666633"
	UCB_RED					  = "993333"
  
  attr_reader :pdf
  
  def initialize(order)
    @pdf = Prawn::Document.new #(page_size: 'A4')
    @page_width = @pdf.bounds.width
    build(order)  
  end
  
  def print
    @pdf.print
  end
  
  def render
    @pdf.render
  end
  
  private
  
  def widths(cols)
    column_widths = []
    cols.each do |col|
      column_widths << col * @page_width / 100.0
    end
    column_widths
  end
  
  def build(order)
    header(order)
    details(order)
    footer(order)
    @pdf.number_pages("UnitingCare Ballarat Purchase Order number #{order.id} - page <page> of <total>", {:at => [0,0], :align => :center})	
  end

  def header(order)
    @pdf.table([
			[{:image => "#{Rails.root}/app/assets/images/UCB-grayscale.jpg", :scale => 0.07},
       {:content => "UnitingCare Ballarat\n<font size='8'>ABN: 15 562 149 440</font>\nPO Box 608\nBallarat  Vic  3353\nTelephone: (03) 5332 1286\nFax: (03) 5332 1055", :inline_format => true},   
			 {:content => 'Purchase Order', :align => :right, :size => 20, :font_style => :bold}]
		], :column_widths => widths([40,30,30])) do
			cells.padding = 1
			cells.borders = []
		end
    
    @pdf.move_down(20)
  	@pdf.table([
      [{:content => order.supplier_name}, 
       {:content => 'PO Number:'},
       {:content => order.id.to_s, :font_style => :bold, :size => 14 }],
      [{:content => order.supplier_address1},
       {:content => 'Issue Date:'},
       {:content => format_date(order.approved_at)}],
      [{:content => order.supplier_address2},
       {:content => 'Your Reference:'},
       {:content => order.reference}],
      [{:content => order.supplier_address3},
       {:content => 'Supplier Number:'},
       {:content => order.supplier_id.to_s}] 
		], :column_widths => widths([50,25,25])) do
			cells.padding = 1
			cells.borders = []
      column([1,2]).style(:align => :right)
      column(1).style(:font_style => :bold)
    end
    
    @pdf.move_down(20)
  end
  
  def details(order)
    data = [['Description','Cost']]
    order.items.each do |item|
      data << [item.description,sprintf('%.2f', item.subtotal)]
    end
		
    @pdf.table(data, 
      :row_colors => [ROW_COLOUR_EVEN, ROW_COLOUR_ODD],
			:header => :true, 
			:column_widths => widths([75,25])) do
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
      :row_colors => [ROW_COLOUR_EVEN, ROW_COLOUR_ODD],
			:header => :true, 
			:column_widths => widths([25,25])) do
			cells.padding = [2,5,2,5]
			cells.borders = []
			
      row(0).background_color = ROW_COLOUR_ODD
      row(2).font_style = :bold
			row(2).background_color = ROW_COLOUR_HEAD
      column(0).style(:align => :right)
      column(1).style(:align => :right)
		end
  end
  
  def footer(order)
  	@pdf.move_down(20)
  	data = [
  	  ["1.","A complying Tax Invoice must be submitted to UnitingCare Ballarat before payment for goods/services can be made."],
      ["2.","Invoices and related correspondence must quote our Purchase Order Number: <b>#{order.id}</b>"],
      ["3.","A delivery docket must be provided with all delivered goods."],
      ["4.","Acceptance by the Supplier of this Purchase Order is deemed to be acceptance of UCB Purchase Order Terms & Conditions. Refer to UCB website (ucare.org.au) for details."]
  	]
    @pdf.table(data, 
			:cell_style => {:size => 8,:inline_format => true},
      :column_widths => widths([2,98])) do
      cells.borders = []
      cells.padding = 0 
    end
    
    @pdf.move_down(20)
  	data = [
  	  ['Invoice to:','Deliver to:','Authorised by:'],
      ["Finance Department\nUnitingCare Ballarat\nPO Box 608\nBallarat  Vic  3353\nor accounts@ucare.org.au",
       "#{order.delivery_address}",
       "#{order.approver.name}\n#{order.approver.phone}"]
  	]
    @pdf.table(data, 
			:cell_style => {:inline_format => true},
      :column_widths => widths([40,40,20])) do
      cells.borders = []
      cells.padding = [5,0,0,0] 
      row(0).font_style = :bold_italic 
      column(2).style(:align => :right)
    end
  end
  
  def format_date(date)
    date ? "#{date.strftime('%d %b %Y')}" : ''
  end
end