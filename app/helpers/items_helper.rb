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
end
