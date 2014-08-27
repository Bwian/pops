#!/usr/bin/env ruby
require 'tiny_tds'
require 'pry'
require 'base64'

class StoredProcedure
  
  def initialize(connection,db)
    @connection = connection
    @db = db
    @main_list = build_list
    @filtered_list = []
    puts 'Select from list or enter partial name to filter list'
    puts '0 - clear filter'
    puts 'q - quit'
  end
  
  def build_list
    out = []
    begin
      result = @connection.execute("select ROUTINE_NAME from #{@db}.information_schema.routines order by ROUTINE_NAME")
      result.each(:symbolize_keys => true) do |row|
        out << row[:ROUTINE_NAME]
      end
    rescue TinyTds::Error => excp
      puts excp.message
    end
    out
  end
  
  def list_sps(filter)
    @filtered_list = []
    idx = 1
    @main_list.each do |name|
      if name =~ /#{filter}/
        printf("%2d - %s\n",idx,name)
        @filtered_list << name
        idx += 1
      end
    end
  end

  def display_sp(line)
    idx = line.to_i
    if idx > @filtered_list.size
      puts 'Invalid selection'
    else
      idx -= 1
    end  
	
    result = @connection.execute("sp_helptext #{@filtered_list[idx]}")
	  result.each(:symbolize_keys => true) do |row|
		  puts row[:Text]
	  end
  end

  def go
    list_sps('.*')

    loop do
      'Select SP or filter: '.display
      input = $stdin.gets.chomp
      case input
        when '0'
          list_sps('.*')
        when 'q'
          exit
        when 'h'
          puts '0 - clear filter'
          puts 'q - quit'
        when /^[0-9]+$/
          display_sp(input)
        else
          list_sps(input)
      end
    end
  end
end

class Select
  
  def initialize(connection,db)
    @connection = connection
    @db = db
    puts 'Enter query stmt'
    puts 'l - last CR_TRANS insert'
    puts '/ - repeat last query'
    puts 'q - quit'
    puts
  end
  
  def get_results(stmt)
    begin
      result = @connection.execute(stmt)
      result.each(:symbolize_keys => true) do |row|
        row.each do |key,value|
          printf("%20s: %s\n",key,value)
        end
        puts
      end
    rescue TinyTds::Error => excp
      puts excp.message
    end
  end
  
  def go
    last_input = ''
    loop do
      'Select: '.display
      input = $stdin.gets.chomp
      case input
        when 'q'
          exit
        when 'l'
          get_results('select * from CR_TRANS where SEQNO = (select max(SEQNO) from CR_TRANS)')
          get_results('select * from CR_INVLINES where HDR_SEQNO = (select max(SEQNO) from CR_TRANS)')
        when '/'
          get_results(input)
        else
          get_results(input)
          last_input = input
      end
    end  
  end
end

db = 'EXO_UCB'
klass = Select
ARGV.each do |arg|
  case arg
    when '-t'
      db = 'EXO_UCB_TEST'
    when '-p'
      klass = StoredProcedure
  end
end

puts "Using #{db}"

begin
  connection = TinyTds::Client.new(username: 'exouser', password: Base64.decode64('YWNhY2lh'), dataserver: 'ucfinance')
  connection.execute("use [#{db}]").do
rescue TinyTds::Error => excp
  puts "Can't connect to database [#{db}] - #{excp.message}"
  exit
end

obj = klass.new(connection,db)
obj.go
