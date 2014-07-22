class ExoUpdater
  attr_reader :notice
  
  def initialize(klass,data)
    @notice = ''
    process(klass,data)
  end
  
  private
  
  def process(klass,data)
    insert_count = 0
    found_count = 0
    data.each do |record|
      next if klass.exists?(record[:id])
      found_count += 1
      model = klass.new
      record.each do |key,value|
        model.send("#{key}=",value)
      end
      model.status = 'N'
      insert_count += 1 if model.save
    end
    
    if data.size == 0
      @notice = 'No Exo records found!'
    else
      @notice = "#{data.size} Exo records processed - "
      @notice += found_count == 0 ? 'No new records found.' : "#{insert_count} new records inserted of #{found_count} found."
    end
  end
  
end