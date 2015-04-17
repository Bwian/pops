require 'elif'

class ParseLog
  
  attr_reader :log
  
  def initialize(filename)
    @log = []
        
    Elif.open(filename, "r") do |f|
      f.each_line do |line|
        @log << parse(line)
        break if line =~ /Processing Telstra Bill File/
      end
    end
    
    @log.reverse!
  end
  
  def each(&blk)
    @log.each(&blk)
  end
  
  private
  
  def parse(s)
    out = []
    
    fields = s.split(' ')
    t = Time.parse(fields[1])
    
    out[0] = fields[3].downcase
    out[1] = t.strftime("%A %b %-d")
    out[2] = t.strftime("%H:%M:%S")
    out[3] = s.split('-- : ')[1].chomp  
    
    out
  end
end