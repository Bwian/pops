module ItemsHelper
  DEFAULT_TAX_RATE = 32
  AUTO_TAX_RATE = -1
  
  def default_tax_rate(item)   
    item && item.tax_rate_id ? item.tax_rate_id : get_tax_rate(item)
  end

  def program_select(item,readonly,flag)
    select :item, :program_id, program_list(item,flag), 
      { include_blank: 'Select a program', selected: item.program_id },
      { disabled: readonly, class: "btn btn-primary btn-select" }
  end
  
  def account_select(item,readonly,flag)
    select :item, :account_id, account_list(item,flag), 
      { include_blank: 'Select an account', selected: item.account_id },
      { disabled: readonly, onchange: "javascript:tax_rate()", class: "btn btn-primary btn-select" }
  end
  
  def tax_rate_select(item,readonly)
    select :item, :tax_rate_id, tax_list(item), 
      { include_blank: 'Select a tax rate', selected: default_tax_rate(item) },
      { disabled: readonly, class: "btn btn-primary" }
  end
  
  private
  
  def get_tax_rate(item)
    if item.order.supplier && item.order.supplier.tax_rate_id != AUTO_TAX_RATE
      return item.order.supplier.tax_rate_id
    end
    
    if item.account && item.account.tax_rate_id != AUTO_TAX_RATE
      return item.account.tax_rate_id
    end
 
    DEFAULT_TAX_RATE    
  end
  
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
  
  def program_list(item,flag)
    filter = User.find(session[:user_id]).programs_filter
    
    select_list(filter,Program.selection,item.program_id,flag)
  end
  
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
end
