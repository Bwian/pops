module OrdersHelper
  def link_item_new(order)
    session[:admin] ? link_to("Add Item", "/orders/#{order.id}/items/new", class: ApplicationHelper::LINK_STYLE) : ""
  end

  def link_action(order)  
    actions = []
    case order.status
      when OrderStatus::DRAFT
        actions = ['submit'] if order.items.any?
      when OrderStatus::SUBMITTED
        actions = ['draft','approve']
      when OrderStatus::APPROVED
        actions = ['submit','complete']
    end
    
    links = []
    actions.each do |action|
      link = session[:admin] ? link_to(action_label(action), "/orders/#{order.id}/#{action}", method: :post, class: ApplicationHelper::LINK_STYLE) : ""
      links << link
    end
    
    links
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
    actions << link_list(order)
  end
  
  def roles
    user = User.find(session[:user_id])
    user ? user.roles : []
  end
    
  private
  
  def action_label(action)
    action == 'complete' ? 'Process' : action.capitalize
  end
end
