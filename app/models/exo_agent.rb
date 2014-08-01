require 'tiny_tds'

class ExoAgent
  
  NIL = 'nil'
  
  attr_reader :notice
  attr_writer :host, :port, :user, :database
  
  def initialize
    @names = {    
      'Account'     => 'GLACCS',
      'PaymentTerm' => 'CREDIT_STATUSES',
      'Program'     => 'BRANCHES',
      'Supplier'    => 'CR_ACCS',
      'TaxRate'     => 'TAX_RATES'     
    }
    
    @tables = {
      'Account'     => { ACCNO: :id, NAME: :name, TAXSTATUS: :tax_rate_id },
      'PaymentTerm' => { STATUSNO: :id, STATUSDESC: :name, CREDIT_FACTOR: :factor },
      'Program'     => { BRANCHNO: :id, BRANCHNAME: :name },
      'Supplier'    => { ACCNO: :id, NAME: :name, ADDRESS1: :address1, ADDRESS2: :address2, ADDRESS3: :address3, PHONE: :phone, FAX: :fax, EMAIL: :email, TAXSTATUS: :tax_rate_id, CREDITSTATUS: :payment_term_id },
      'TaxRate'     => { SEQNO: :id, NAME: :name, SHORTNAME: :shortname, RATE: :rate }
    }
    
    @notice = ''
    
    @connection = nil
    @host = '152.100.100.68'
    @port = 1433
    @login_timeout = 1
    @user = 'exouser'
    @password = 'acacia'
    @database = 'EXO_UCB_TEST'
  end
  
  def extract(table)
    return nil unless connect
    
    results = @connection.execute(build_select(table))
    fields = @tables[table.name]
    rows = []
    results.each(:symbolize_keys => true) do |r|
      row = {}
      r.each do |key,value|
        row[fields[key]] = value
      end
      rows << row
    end
    @connection.close
    rows
  end
  
  def complete(order)
    return false unless connect
    
    invoice_id = insert('ACS_Create_CrInv_Hdr_Record',
      order.supplier_id,
      DateTime.now, # or order.invoice_date ???
      order.invoice_no || NIL,
      order.reference,
      NIL, # REF2
      order.subtotal,
      order.gst, # or grandtotal ???
      0.0, # MANUAL_ROUNDING
      NIL, # SALESNO
      order.payment_date || NIL,
      NIL, # X_SIMPRO_ID
      NIL, # X_SIMPRO_COMPANY
      NIL  # BRANCHNO
    )

    return false if !invoice_id
    
    @order.items.each do |item|
      return false if !insert('ACS_Create_CrInv_GLLine_Record',
      order.supplier_id,
      order.invoice_no,
      invoice_id,
      item.program_id,
      item.account_id,
      NIL, # GLSUBACC
      item.description,
      1.0, # QUANTITY
      item.price,
      item.tax_rate_id,
      DateTime.now, # or something else ???
      NIL # LINKED_STOCKCODE
      )
    end
    
    @connection.close
    return true
  end
  
  private

  def build_select(table)
    table_name = table.name
    s = ''
    @tables[table_name].each_key do |field|
      s += "#{field} "
    end
    "select #{s.strip.gsub(' ',',')} from [#{@names[table_name]}]"
  end

  
  def valid?
    [:host,:port,:user,:password,:database].each do |vbl|
      unless self.instance_variable_get("@#{vbl.to_s}")
        @notice = "SQL Server configuration invalid - missing #{vbl.to_s} setting"
        return false
      end
    end
    
    @login_timeout = 1 if !@login_timeout || @login_timeout == 0
    return true
  end 
   
  def connect
    return false unless valid?
    
    begin
      @connection = TinyTds::Client.new(
        host: @host,
        port: @port,
        username: @user,
        password: @password,
        login_timeout: @login_timeout
      )  
      @connection.execute("use [#{@database}]").do
    rescue TinyTds::Error
      @notice = "Could not create connection to SQL Server database [#{@database}] at #{@host}:#{@port}e"
      return false
    end
    return true
  end
  
  def insert(proc,args)
    exec = "[#{proc}] #{args.join(' ')}"
    stmt = "declare @SeqNo int; exec #{exec} ; select @SeqNo as seqno;"
    seqno = nil
    begin
      result = client.execute(stmt)
      result.each(:symbolize_keys => true) do |row|
        seqno = row[:seqno]
      end
    rescue TinyTds::Error
      @notice = "Error processing: #{exec}"
      return nil
    end
    @notice = "Insert failed: #{exec}" unless seqno
    
    return seqno
  end
  
end