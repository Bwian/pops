class OrderStatus
  
  DRAFT     = 'D'
  SUBMITTED = 'S'
  APPROVED  = 'A'
  PROCESSED = 'P'
  
  STATUS = {
    DRAFT     => 'Draft',
    SUBMITTED => 'Submitted',
    APPROVED  => 'Approved',
    PROCESSED => 'Processed'
  }
  
  def self.draft
    STATUS[DRAFT]
  end

  def self.approved
    STATUS[APPROVED]
  end

  def self.submitted
    STATUS[SUBMITTED]
  end

  def self.processed
    STATUS[PROCESSED]
  end

  # Status description if valid otherwise 'Invalid' message
  def self.status(code)
    STATUS[code] ? STATUS[code] : "Invalid status - #{code ? code : 'nil'}"
  end
end