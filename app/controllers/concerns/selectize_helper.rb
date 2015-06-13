module SelectizeHelper
  
  def tax_list(item)
    limited_selection = TaxRate.limited_selection
    return TaxRate.selection if User.find(session[:user_id]).processor
    return limited_selection unless item.tax_rate_id
    unless limited_selection.detect {|rate| rate[1] == item.tax_rate_id}
      limited_selection << [item.tax_rate.name,item.tax_rate_id]
    end
    limited_selection 
  end
  
  def account_list(item,flag)
    filter = User.find(session[:user_id]).accounts_filter
    filter = '6000-' if filter.nil? || filter.empty?
    select_list(filter,Account.selection,item.account_id,flag)
  end
  
  def program_list(item,flag,json)
    filter = User.find(session[:user_id]).programs_filter  
    list = select_list(filter,Program.selection,item.program_id,flag)
    json ? json_list(list) : list
  end
  
  private
  
  def select_list(filter,list,current_id,flag)
    ranges = build_ranges(filter)
    return list if ranges.empty? 
    return list if !flag
    
    current_id = '\\' if current_id.nil?
    filtered_list = []
    list.each do |line|
      ranges.each do |range|
        filtered_list << line if range.cover?(line[1])
      end
      filtered_list << line if !filtered_list.detect {|s| s[1] == current_id } && current_id == line[1]
    end
    filtered_list
  end
  
  def build_ranges(filter)
    ranges = []
    filter = '' if filter.nil?
    
    filter.split(/,| /).each do |f|
      fromto = f.split('-')
      case fromto.size
        when 0
          next
        when 1
          from = fromto[0].to_i
          to = f.last == '-' ? 1.0/0.0 : from
        else
          from = fromto[0].to_i
          to = fromto[1].to_i
      end
      range = from..to
      ranges << range
    end
     
    ranges 
  end
  
  def json_list(list)
    selectize_list = [] 
    list.each do |a|
      selectize_list << { text: a[0], value: a[1] }
    end
    selectize_list.to_json
  end
  
end