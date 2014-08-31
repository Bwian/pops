require 'net-ldap'

class LdapAgent
  
  attr_reader :notice
  attr_writer :host, :port, :user, :password
  
  def initialize
    @notice = ''
    
    @connection    = nil
    @host          = ENV['ldap_host']
    @port          = (ENV['ldap_port'] || 389).to_i
    @user          = ENV['ldap_login']
    password       = ENV['ldap_password']
    @password      = password ? Base64.decode64(password) : ''
  end
  
  def authenticate(login,password)
    @user = login
    @password = password
    connect
  end
  
  private
 
  def valid?
    [:host,:port,:user,:password].each do |vbl|
      unless self.instance_variable_get("@#{vbl.to_s}")
        @notice = "LDAP configuration invalid - missing #{vbl.to_s} setting"
        return false
      end
    end

    return true
  end 
   
  def connect
    return false unless valid?
    
    begin
      @connection = Net::LDAP.new(
        host: @host,
        port: @port,
        base: "dc=ballarat_thm",
        auth: {
          method: :simple,
          username: @user,
          password: @password 
        }
      )  
    
      unless @connection.bind
        build_notice "#{@connection.get_operation_result.message}(#{@connection.get_operation_result.code})"
        return false
      end
    
    rescue Net::LDAP::LdapError => excp
      build_notice excp.message 
      return false
    end
    
    return true
  end
  
  def build_notice(message)
    @notice = "Could not create connection to LDAP Server at #{@host}:#{@port} due to: #{message}"
  end
  
end