module OrdersHelper
  
  COLUMN_HEADERS = {
    id:            'PO Number',
    supplier_name: 'Supplier',
    invoice_no:    'Invoice',
    amount:        'Amount',
    created_at:    'Created',
    creator_id:    'By',
    approved_at:   'Approved',
    approver_id:   'By',
    status:        'Status'
  }
  
  ARROW = {
    'asc'      => '&uarr;',
    'desc'     => '&darr;'
  }
  
  def link_item_new(order)
    authorised_action(NEW,ITEMS,order) ? link_to("Add Item", new_order_item_path(order), class: ApplicationHelper::LINK_STYLE) : ""
  end

  def link_action(order)  
    actions = []
    case order.status
      when OrderStatus::DRAFT
        actions = ['submit'] 
      when OrderStatus::SUBMITTED
        actions = ['approve','redraft']
      when OrderStatus::APPROVED
        actions = ['complete','resubmit']
    end
    
    links = []
    btn_class = ApplicationHelper::FIRST_STYLE
    actions.each do |action|
      link = authorised_status_change(action,order) ? link_to(action_label(action), "/orders/#{order.id}/#{action}", method: :post, class: btn_class) : ""
      links << link
      btn_class = ApplicationHelper::LINK_STYLE
    end
    
    links
  end
  
  def link_print(order)
    authorised_action(PRINT,ORDERS,order) ? link_to('Print', "/orders/#{order.id}/print", format: 'pdf', class: ApplicationHelper::LINK_STYLE) : ""
  end
  
  def order_actions(order,readonly)
    actions = []
    if readonly
      actions.concat(link_action(order))
      actions << link_item_new(order)
      actions << link_edit(order)
      actions << link_delete(order)
    else  
      submit_label = order.id ? 'Update Order' : 'Create Order'
      actions << submit_tag(submit_label, class: ApplicationHelper::LINK_STYLE)
    end
    actions << link_print(order) unless link_print(order).empty?
    actions << link_list(order)
  end
  
  def roles
    user = User.find(session[:user_id])
    user ? user.roles : []
  end
  
  def order_header(key)
    arrow = key.to_s == session[:sort_by] ? ARROW[session[:sort_order]] : ''
    "#{COLUMN_HEADERS[key]} #{arrow}".html_safe
  end
  
  def order_sort_header(column)
    link_to order_header(column), orders_path(sort: column)
  end
  
  def html_newlines(text)
    text.gsub("\n","</br>").html_safe
  end
    
  private
  
  def action_label(action)
    action == 'complete' ? 'Process' : action.capitalize
  end
end
