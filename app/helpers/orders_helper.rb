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
  
  def link_item(item)
    action = authorised_action(EDIT,ITEMS,item) ? 'edit' : 'show'
    link_to(item.description, url_for(controller: 'items', id: item.id, action: action),class: "link_hilight")
  end
  
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
        actions = ['receive','resubmit']
      when OrderStatus::RECEIVED
        actions = ['complete','reapprove']
        actions << 'receive' if order.grandtotal > order.receipt_total
    end
    
    links = []
    btn_class = ApplicationHelper::FIRST_STYLE
    actions.each do |action|
      link = ""
      if authorised_status_change(action,order)
        case action
          when 'redraft','resubmit','reapprove'
            link = link_notes(action)
          when 'receive'
            link = link_to(action_label(action), url_for(controller: 'receipts', id: order.id, action: :new), class: btn_class) 
          when 'complete'
            link = button_tag('Process', type: 'button', onclick: "javascript:update_it('complete')".html_safe, class: btn_class)
          else 
            link = link_to(action_label(action), url_for(controller: 'orders', id: order.id, action: action), method: :post, class: btn_class)
          end
      end
      links << link
      btn_class = ApplicationHelper::LINK_STYLE
    end
    
    links
  end
  
  def link_reaction(order,noupdate)
    return button_tag('OK', data: {dismiss: 'modal'}, class: ApplicationHelper::LINK_STYLE) if !noupdate
    
    case order.status
      when OrderStatus::SUBMITTED
        action = 'redraft'
      when OrderStatus::APPROVED
        action = 'resubmit'
      when OrderStatus::RECEIVED
        action = 'reapprove'
      else
        action = nil
    end
    
    action ? button_tag(action_label(action), data: {dismiss: 'modal'}, onclick: "javascript:submit_it('#{action}')".html_safe, class: ApplicationHelper::LINK_STYLE) : ""
  end
  
  def link_print(order)
    return '' unless order && order.id
    authorised_action(PRINT,ORDERS,order) ? link_to('Print', url_for(controller: 'orders', id: order.id, action: 'print'), target: '_blank', class: ApplicationHelper::LINK_STYLE) : ""
  end
  
  def link_notes(action)
    button_tag(action.capitalize, data: {toggle: 'modal', target: '#notes'}, class: ApplicationHelper::LINK_STYLE)   
  end
  
  def processing?(order,readonly)
    order.received? && authorised_status_change('complete',order) && readonly
  end
  
  def order_actions(order,readonly)
    actions = []
    if readonly
      actions.concat(link_action(order))
      actions << link_item_new(order)
    else  
      submit_label = order.id ? 'Update Order' : 'Create Order'
      actions << submit_tag(submit_label, class: ApplicationHelper::LINK_STYLE)
      actions << link_notes('notes')
    end
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
