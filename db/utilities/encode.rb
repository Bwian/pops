#!/usr/bin/env ruby

require 'base64'

password = ARGV[0]
if password.nil?
	puts 'Usage: "encode.rb string" - string to be encoded must be supplied'
else
	puts "#{password} = #{Base64.encode64(password)}"
end
