class OrderPdf
  
	ROW_COLOUR_HEAD   = "BBBBBB"
  
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
  
  def build(order)
    header(order)
    data = []
    order.items.each do |item|
      data << [item.description,item.formatted_subtotal,item.formatted_gst,item.formatted_price]
    end
    line_count = data.size
    (data.size..15).each { data << [' ',' ',' ',' '] }
    
    details(order,data[0..14])
    if line_count <= 15 
      totals(order)
      footer(order)
    else
      continued(order)
      footer(order)
      details(order,data[15..data.size])
      totals(order)
    end
    @pdf.number_pages("UnitingCare Ballarat Purchase Order number #{order.id} - page <page> of <total>", {:at => [0,0], :align => :center})	
  end

  def header(order)
    unless order.authorised?
      watermark('Unauthorised') 
    else
      watermark(ENV['order_watermark'])
    end
    
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
  
  def details(order,data)
    data.unshift ['Description','Ex GST','GST','Total']
    @pdf.table(data, 
			:header => :true, 
			:column_widths => widths([58,15,12,15])) do
			cells.padding = [2,5,2,5]
			cells.borders = [:left,:right]
      column([1,2,3]).style(:align => :right)
      row(0).style(:borders => [:top,:bottom,:right,:left],:padding => 5,:font_style => :bold,:background_color => ROW_COLOUR_HEAD)      
		end
  end
  
  def continued(order)   
    contact = "#{order.creator.name} - #{order.creator.phone} - #{order.creator.email}"
    data = [
      ['For enquiries, please contact:',' ','Continued'],
      [contact,' ','on next page'],
      [' ',' ',' ']
    ]
    detail_end(data)
  end
  
  def totals(order)
    contact = "#{order.creator.name} - #{order.creator.phone} - #{order.creator.email}"
    data = [
      ['For enquiries, please contact:','Ex GST:',order.formatted_subtotal],
      [contact,'GST:',order.formatted_gst],
      ['','Total:',order.formatted_grandtotal]
    ]
    detail_end(data)
  end
  
  def detail_end(data)
    @pdf.table(data,
  		:column_widths => widths([73,12,15])) do
  		cells.padding = [2,5,2,5] 
      column([1,2]).style(:align => :right)
      
      cells.borders = []
      rows(0).columns(0).style(:borders => [:left,:top])
      rows(0).columns(1..2).style(:borders => [:right,:top])
      rows(1).columns(0).style(:borders => [:left],:font_style => :bold)
      rows(1).columns(1..2).style(:borders => [:right])
      rows(2).columns(0).style(:borders => [:left,:bottom])
      rows(2).columns(1..2).style(:borders => [:right,:bottom],:font_style => :bold)
    end
  end
  
  def footer(order)
  	@pdf.move_down(10)
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
    
    approved = order.authorised? ? "#{order.approver.name}\n#{order.approver.phone}" : "Not yet approved"
    @pdf.move_down(10)
  	data = [
  	  ['Invoice to:','Deliver to:','Authorised by:'],
      ["Finance Department\nUnitingCare Ballarat\nPO Box 608\nBallarat  Vic  3353\nor accounts@ucare.org.au",
       "#{order.delivery_address}", approved]
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
  
  def watermark(text)
    @pdf.rotate(45, origin: [100,150]) do
      @pdf.fill_color "CFCFCF"
      @pdf.font("Times-Roman", :size => 72, :font_style => :bold) do
        @pdf.draw_text text, :at => [150,150]
      end
      @pdf.fill_color "000000"
    end
  end
  
  def format_date(date)
    date ? "#{date.strftime('%d %b %Y')}" : ''
  end
  
  def widths(cols)
    column_widths = []
    cols.each do |col|
      column_widths << col * @page_width / 100.0
    end
    column_widths
  end
end