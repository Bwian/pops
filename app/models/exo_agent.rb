require 'tiny_tds'

class ExoAgent
  
  NIL = 'NULL'
  
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
      'TaxRate'     => { SEQNO: :id, NAME: :name, SHORTNAME: :short_name, RATE: :rate }
    }
    
    @notice = ''
    
    @connection    = nil
    @host          = ENV['sql_server_host']
    @port          = (ENV['sql_server_port'] || 1433).to_i
    @database      = ENV['sql_server_db']
    @login_timeout = (ENV['sql_server_timeout'] || 1).to_i
    @user          = ENV['sql_server_login']
    @password      = ENV['sql_server_password'] 
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
      quote(order.invoice_date.to_s), # or today ???
      quote(order.invoice_no),
      quote(order.reference),
      quote("PO-#{order.id}"), # REF2
      order.formatted_subtotal,
      order.formatted_gst, # or grandtotal ???
      0.0, # MANUAL_ROUNDING
      NIL, # SALESNO
      quote(order.payment_date.to_s),
      NIL, # X_SIMPRO_ID
      NIL, # X_SIMPRO_COMPANY
      NIL  # BRANCHNO
    )

    return false if !invoice_id
    
    order.items.each do |item|
      return false if !insert('ACS_Create_CrInv_GLLine_Record',
      order.supplier_id,
      quote(order.invoice_no),
      invoice_id,
      item.program_id,
      item.account_id,
      NIL, # GLSUBACC
      quote(item.description),
      1.0, # QUANTITY
      item.formatted_price,
      item.tax_rate_id,
      quote(Date.today.to_s), # or something else ???
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
        password: Base64.decode64(@password),
        login_timeout: @login_timeout
      )  
      @connection.execute("use [#{@database}]").do
    rescue TinyTds::Error => excp
      @notice = "Could not create connection to SQL Server database [#{@database}] at #{@host}:#{@port} due to: #{excp.message}"
      return false
    end
    return true
  end
  
  def insert(proc,*args)
    exec = "[#{proc}] #{args.join(', ')}"
    stmt = "declare @SeqNo int; exec #{exec},@SeqNo OUTPUT; select @SeqNo as seqno;"
    seqno = nil
    begin
      result = @connection.execute(stmt)
      result.each(:symbolize_keys => true) do |row|
        seqno = row[:seqno]
      end
    rescue TinyTds::Error => excp
      @notice = "Error (#{excp.message}) processing: #{exec}"
      return nil
    end
    @notice = "Insert failed: #{exec}" unless seqno
    
    return seqno
  end
  
  def quote(vbl)
    "'#{vbl}'"
  end
  
end