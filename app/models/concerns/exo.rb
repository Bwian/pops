module Exo
  ACTIVE  = 'A'
  DELETED = 'D'
  NEW     = 'N'
  
  STATUS = {
    ACTIVE  => 'Active',
    DELETED => 'Deleted',
    NEW     => 'New'
  }

  # Status description if valid otherwise 'Invalid' message
  def self.status_desc(code)
    STATUS[code] ? STATUS[code] : "Invalid status - #{code || 'nil'}"
  end 
end