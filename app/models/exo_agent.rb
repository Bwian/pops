require 'tiny_tds'

class ExoAgent
  
  attr_reader :notice
  attr_writer :host, :port, :user, :database
  
  def initialize
    @names  = {    
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
    @password = nil
    @database = 'EXO_UCB_TEST'
  end
  
  def extract(table,password)
    @password = password
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
  
  private

  def build_select(table)
    table_name = table.name
    s = ''
    @tables[table_name].each_key do |field|
      s += "#{field} "
    end
    "select #{s.strip.gsub(' ',',')} from [#{@names[table_name]}]"
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
      @notice = "Connection to SQL Server database [#{@database}] at #{@host}:#{@port} failed"
      return false
    end
    return true
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
   
end