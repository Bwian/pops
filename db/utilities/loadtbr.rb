#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/../../config/environment"
require 'pry'

fname = ARGV[0] || 'tbr.csv'
count = 0

CSV.foreach(fname) do |fields|
  manager = User.find_by_code(fields[1])
  puts "User record for #{fields[1]} not found for #{fields[0]}"
  ts = TbrService.new
  ts.code         = fields[0]
  ts.manager_id   = manager ? manager.id : nil
  ts.name         = fields[2]
  ts.cost_centre  = fields[3]
  ts.rental       = fields[4]
  ts.service_type = fields[5]
  ts.comment      = fields[6]
  
  if ts.save
    count += 1
  else
    puts "Unable to save #{fields[0]} - #{fields[1]}"
  end
end

puts "#{count} records added."
