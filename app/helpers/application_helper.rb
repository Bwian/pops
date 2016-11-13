module ApplicationHelper
  
  LINK_STYLE  = "btn btn-primary btn-sm"
  FIRST_STYLE = "btn btn-success btn-sm"
  
  def app_name
    environment = Rails.env.development? ? 'Test' : 'Processing'
    link_to("POPS - Purchase Order #{environment} System", url_for(controller: 'orders'), class: 'navbar-brand')
  end
  
  def link_list(model)
    return '' unless model
    name = model.class.name.underscore.pluralize
    label = model.class.pops_name.pluralize
    link_to("List #{label}", url_for(controller: name), class: LINK_STYLE)
  end
  
  def link_model(model)
    return '' unless model
    name = model.class.pops_name
    link_to(name, model, class: LINK_STYLE)
  end
  
  def link_new(klass)
    name = klass.name.underscore.pluralize
    authorised_action(NEW,params[:controller], nil) ? link_to("New #{klass.pops_name}", url_for(controller: name, action: :new), class: LINK_STYLE) : ""
  end
  
  def link_edit(model)
    return '' unless model && model.id
    name = model.class.name.underscore
    authorised_action(EDIT,params[:controller], model) ? link_to('Edit', url_for(controller: name.pluralize, id: model.id, action: :edit), class: LINK_STYLE) : ""
  end

  def link_delete(model)
    return '' unless model && model.id
    authorised_action(DELETE,params[:controller], model) ? link_to('Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger btn-sm" ) : ""
  end
  
  def link_refresh
    name = params[:controller]
    authorised_action(REFRESH,params[:controller],nil) ? link_to("Refresh #{name.titleize.pluralize}", url_for(controller: name.pluralize, action: :new), class: LINK_STYLE) : ""
  end
  
  def link_logoutin
    return '' if request.fullpath.ends_with?('/login')
    if session[:user_id]  
      user = User.find(session[:user_id])
      link_to("#{user.name} - Logout", url_for(controller: 'sessions', action: :destroy)) 
    else 
      link_to('Login', url_for(controller: 'sessions', action: :new))
    end
  end
  
  def submit_label(model)
    return '' unless model
    name = model.class.pops_name
    action = model.id ? 'Update' : 'Create'
    "#{action} #{name}"
  end
  
  def search
    return '' if request.fullpath.ends_with?('/login')
    text_field_tag(:order_search, nil, class: "form-control search", placeholder: "PO #", onchange: "javascript:order_search()", onkeypress: "javascript:check_enter(event)")
  end
  
  def legend(name,disabled)
    disabled ? name : "Enter #{name}"
  end

  def format_date(datetime)
    datetime ? datetime.strftime('%d/%m/%Y') : ''
  end
  
  def authorised_action(action, controller, model)
    user = User.find(session[:user_id]) 
    
    case controller
      when ORDERS
        allow_access = authorise_orders(user,action,model)
      when ITEMS
        allow_access = authorise_items(user,action,model)
      when 'tbr_services'
        allow_access = authorise_tbr_services(user,action)
      else
        allow_access = session[:admin]
    end
    
    allow_access
  end
  
  def authorised_status_change(action,order)
    user = User.find(session[:user_id])
    
    case action
      when 'draft','redraft'
        return false if !order.submitted?
        return true if order.creator == user || order.approver == user
      when 'submit','resubmit'
        return false if !order.draft? && !order.approved?
        return false if !order.items.any?
        return true if order.draft? && order.creator == user
        return true if order.approved? && order.approver == user
        return true if order.approved? && user.processor?
      when 'approve'
        return false if !order.submitted?
        return true if order.approver == user    
      when 'receive'
        return true if order.approved?
      when 'reapprove'
        return true if order.received?
      when 'complete'
        return false if !order.received?
        return true if user.processor?      
    end
    
    false
  end
  
  def order_link(order)
    order ? order.id : ''
  end
  
  private
  
  def authorise_orders(user,action,order)  
    case action
      when NEW
        allow_access = user.creator
      when EDIT, DELETE  #TODO: change_received?
        allow_access = 
          !order.processed? && 
          change_draft(user,order) &&
          change_submitted(user,order) &&
          change_approved(user,order) &&
          change_received(user,order)
      else
        allow_access = true
    end
    
    allow_access
  end
  
  def authorise_items(user,action,model)
    order = model.class.name == 'Item' ? model.order : model
    
    case action
      when NEW, EDIT, DELETE
        allow_access = 
          !order.processed? && 
          change_draft(user,order) &&
          change_submitted(user,order) &&
          change_approved(user,order) &&
          change_received(user,order)
      else
        allow_access = true
    end
    
    allow_access 
  end
  
  def authorise_tbr_services(user,action)
    case action
      when NEW, EDIT, DELETE
        allow_access = user.tbr_admin
      else
        allow_access = true
    end
    
    allow_access 
  end
  
  def change_draft(user,order)
    return true if !order.draft?
    return false if order.creator != user
    true
  end
  
  def change_submitted(user,order)
    return true if !order.submitted?
    return false if order.approver != user || !user.approver
    true
  end
  
  def change_approved(user,order)
    return true if !order.approved? 
    return false if !user.processor || order.approver != user 
    true
  end
  
  def change_received(user,order)
    return true if !order.received?
    return false if !user.processor
    true
  end
  
  def authorise_draft(user,action,order)
    return true if !order.submitted?
    return false if order.creator != user
    true
  end
end


