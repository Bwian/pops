class ExoUpdater
  attr_reader :notice
  
  def initialize(klass,data)
    @notice = ''
    process(klass,data)
  end
  
  private
  
  def process(klass,data)
    found_count = 0
    insert_count = 0
    update_count = 0
    data.each do |record|
      model = klass.find_by_id(record[:id]) || klass.new
      record.each do |key,value|
        model.send("#{key}=",value)
      end
      if model.changed?
        found_count += 1
        model.status = 'N'
        if model.new_record?
          insert_count += 1 if model.save 
        else
          update_count += 1 if model.save
        end
      end
    end
    
    if data.size == 0
      @notice = 'No Exo records found!'
    else
      @notice = "#{data.size} Exo records processed - "
      @notice += found_count == 0 ? 'No new records found.' : "#{update_count} records updated and #{insert_count} new records inserted of #{found_count} found."
    end
  end
  
end