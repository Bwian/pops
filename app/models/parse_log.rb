require 'elif'

class ParseLog
  
  MAX_LOG = 15
  attr_reader :log
  
  def initialize(filename)
    @log  = []
    count = 0
   
    begin
      Elif.open(filename, "r") do |f|
        s = []
        f.each_line do |line|
          l = parse(line)
          s << l unless l.empty?
          if line =~ /Telstra bill processing started/ 
            @log << s.reverse
            s = []
            count += 1
            break if count > MAX_LOG
          end
        end
      end
    rescue Errno::ENOENT
    end
  end
  
  def session(id)
    idx = id.to_i - 1
    return [] if @log.empty?
    @log[idx] || [] 
  end
  
  def sessions
    tbr_sessions = []
    @log.each do |l|
      tbr_sessions << l[0][:time].strftime("%A %b %-d - %H:%M:%S")
    end
    tbr_sessions
  end
  
  def selection
    selections = []
    sessions.each_index do |idx|
      selections << [sessions[idx],idx+1] unless sessions[idx].empty?
    end
    selections
  end
  
  private
  
  def parse(line)
    fields = line.split(' ')
    begin
      logtime = Time.parse(fields[1])
    rescue ArgumentError
      return {}
    end
    
    out = {}
    out[:type] = fields[3].downcase
    out[:time] = logtime
    out[:desc] = line.split('-- : ')[1].chomp  
    
    out
  end
end