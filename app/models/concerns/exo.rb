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
  def formatted_status
    STATUS[status] ? STATUS[status] : "Invalid status - #{status || 'nil'}"
  end 
end