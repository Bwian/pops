module ItemsHelper
  DEFAULT_TAX_RATE = 32
  AUTO_TAX_RATE = -1
  
  def default_tax_rate(item)   
    item && item.tax_rate_id ? item.tax_rate_id : get_tax_rate(item)
  end
  
  def tax_rate_select(item,readonly)
    select :item, :tax_rate_id, tax_list(item), 
      { prompt: 'Select a tax rate', selected: default_tax_rate(item) },
      { disabled: readonly, class: "btn btn-primary" }
  end
  
  def account_select(item,readonly)
    select :item, :account_id, account_list(item), 
      { prompt: 'Select an account', selected: item.account_id },
      { disabled: readonly, onchange: "javascript:tax_rate()", class: "btn btn-primary btn-select" }
  end
  
  def program_select(item,readonly)
    select :item, :program_id, program_list(item), 
      { prompt: 'Select a program', selected: item.program_id },
      { disabled: readonly, class: "btn btn-primary btn-select" }
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
    return TaxRate.selection if User.find(session[:user_id]).processor
    return TaxRate.limited_selection unless item.tax_rate_id
    return TaxRate.selection unless TaxRate.limited_selection.detect {|rate| rate[1] == item.tax_rate_id}
    TaxRate.limited_selection 
  end
  
  def account_list(item)
    filter = User.find(session[:user_id]).accounts_filter
    select_list(filter,Account.selection,item.account_id)
  end
  
  def program_list(item)
    filter = User.find(session[:user_id]).programs_filter
    select_list(filter,Program.selection,item.program_id)
  end
  
  def select_list(filter,list,current_id)
    ranges = build_ranges(filter)
    return list if ranges.empty?
    
    current_id = 0 if current_id.nil?
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
          to = from
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
