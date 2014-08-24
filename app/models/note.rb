class Note < ActiveRecord::Base
  belongs_to :order 
  belongs_to :user
  
  attr_reader :date_from, :date_to
  
  default_scope { order('created_at DESC') }
  
  validates :order_id,
            :user_id,
            :info,
            presence: true
  
  def self.by_order(order_id)
    where("order_id = ?", order_id)
  end
  
  def self.by_user(user_id)
    where("user_id = ?", user_id)
  end
  
  def self.by_info(info)
    where("info like ?", "%#{info}%")
  end
  
  def self.by_date(from,to)
    from_datetime = from.empty? ? '1/1/2000'.to_datetime : from.to_datetime
    to_datetime = to.empty? ? DateTime.now : to.to_datetime
    where(created_at: from_datetime.beginning_of_day..to_datetime.end_of_day)
  end
  
  def date_from=(date)
    @date_from = parse_date(:date_from,date)
  end
  
  def date_to=(date)
    @date_to = parse_date(:date_to,date)
  end        
    
  def user_name
    self.user ? self.user.name : "Missing User #{self.user_id}"
  end
  
  def formatted_date
    "#{self.created_at.strftime('%d/%m/%Y')} - #{self.created_at.strftime('%H:%M')}"
  end
  
  private
  
  def parse_date(id,date)
    return '' if date.nil? || date.empty?
    
    components = date.split(/\/|-/)
    components.map! { |c| c = c.to_i }
    
    components.each do |c|
      if c == 0
        self.errors.add(id,"contains invalid character - #{date}.  Valid formats include: d/m/yy, d/m and yyyy")
        return ''
      end
    end
    
    case components.size
      when 1
        d = 1
        m = 1
        year = components[0]
      when 2
        d = components[0]
        m = components[1]
        year = Date.today.year
      else
        d = components[0]
        m = components[1]
        year = components[2]
    end
    
    next_year = Date.today.year - 1999
    case year
      when (0..next_year)
        y = year + 2000
      when (next_year..2000)
        self.errors.add(id,"contains invalid year - #{year}  Valid formats include: d/m/yy, d/m and yyyy")
        return ''
      else
        y = year
    end
    
    begin
      parsed_date = Date.new(y,m,d) # catch exception and add error
    rescue ArgumentError
      self.errors.add(id,"is an invalid date format - #{date}.  Valid formats include: d/m/yy, d/m and yyyy")
      return '' 
    end
    
    parsed_date.strftime('%d/%m/%Y')
  end  
end
