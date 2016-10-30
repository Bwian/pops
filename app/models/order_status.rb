class OrderStatus
  
  DRAFT     = 'D'
  SUBMITTED = 'S'
  APPROVED  = 'A'
  RECEIVED  = 'R'
  PROCESSED = 'P'
  
  CREATOR   = 'Creator'
  APPROVER  = 'Approver'
  RECEIVER  = 'Receiver'
  PROCESSOR = 'Processor'
  
  STATUS = {
    DRAFT     => 'Draft',
    SUBMITTED => 'Submitted',
    APPROVED  => 'Approved',
    RECEIVED  => 'Received',
    PROCESSED => 'Processed'
  }

  # Status description if valid otherwise 'Invalid' message
  def self.status(code)
    STATUS[code] ? STATUS[code] : "Invalid status - #{code ? code : 'nil'}"
  end
end