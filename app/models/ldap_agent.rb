require 'net-ldap'

class LdapAgent
  
  attr_reader :notice, :dn, :name, :email, :phone
  attr_writer :host, :port, :user, :password
  
  def initialize
    @notice = ''
    
    @host          = ENV['ldap_host']
    @port          = (ENV['ldap_port'] || 389).to_i
    @base          = ENV['ldap_base']
    @user          = ENV['ldap_login']
    password       = ENV['ldap_password']
    @password      = password ? Base64.decode64(password) : ''
		
		@connection    = Net::LDAP.new(host: @host, port: @port, base: @base) 
  end
  
  def authenticate(login,password)
    connect(login,password)
  end
  
  def search(user_code)
    result = {}
    if connect(@user,@password)
      @connection.search(
        filter: Net::LDAP::Filter.eq(:samaccountname, user_code), 
        attributes: [:name, :mail, :telephonenumber], 
        return_result: false
      ) { |item|
        result = item
        break
      }
    end
    
    if result == {}
			@notice = "No LDAP entry found for #{user_code}"
			return false
		end

		@dn    = set_ldap(result[:dn])
		@name  = set_ldap(result[:name])
		@email = set_ldap(result[:mail])
		@phone = set_ldap(result[:telephonenumber])	

		return true
  end
 
  private
 
  def valid?
    [:host,:port,:base,:user,:password].each do |vbl|
      unless self.instance_variable_get("@#{vbl.to_s}")
        @notice = "LDAP configuration invalid - missing #{vbl.to_s} setting"
        return false
      end
    end

    return true
  end 
   
  def connect(user,password)
    return false unless valid?
    
		if user.nil? || user.empty? || password.nil? || password.empty?
			@notice = 'Login or password not supplied'
			return false
		end

    begin
      @connection.auth user,password

      unless @connection.bind 
        build_notice "#{@connection.get_operation_result.message}(#{@connection.get_operation_result.code})"
        return false
      end
    
    rescue Net::LDAP::Error => excp
      build_notice excp.message 
      return false
    end
    
    return true
  end
  
  def build_notice(message)
    @notice = "Could not create connection to LDAP Server at #{@host}:#{@port} due to: #{message}"
  end
 	
	def set_ldap(param)
    return '' if param.nil? || param.size == 0
    param.first
  end 
end
