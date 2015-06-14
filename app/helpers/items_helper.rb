module ItemsHelper

  include SelectizeHelper
  
  DEFAULT_TAX_RATE = 32
  AUTO_TAX_RATE = -1
  
  def default_tax_rate(item)   
    item && item.tax_rate_id ? item.tax_rate_id : get_tax_rate(item)
  end

  def program_select(item,readonly,flag)
    select :item, :program_id, program_list(item,flag,false), 
      { include_blank: 'Select a program', selected: item.program_id },
      { disabled: readonly }
  end
  
  def account_select(item,readonly,flag)
    select :item, :account_id, account_list(item,flag,false), 
      { include_blank: 'Select an account', selected: item.account_id },
      { disabled: readonly, onchange: "javascript:tax_rate()" }
  end
  
  def tax_rate_select(item,readonly)
    select :item, :tax_rate_id, tax_list(item), 
      { include_blank: 'Select a tax rate', selected: default_tax_rate(item) },
      { disabled: readonly }
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
  
end
