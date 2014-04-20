module ApplicationHelper
  
  LINK_STYLE  = "btn btn-primary btn-sm"
  FIRST_STYLE = "btn btn-success btn-sm"
  
  def link_list(model)
    name = model.class.name.downcase
    link_to("List #{name.titleize.pluralize}", "/#{name.pluralize}", class: LINK_STYLE)
  end
  
  def link_model(model)
    name = model.class.name.camelcase
    link_to(name, model, class: LINK_STYLE)
  end
  
  def link_new(name)
    authorised_action(NEW,params[:controller], nil) ? link_to("New #{name.titleize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
  end
  
  def link_edit(model)
    name = model.class.name.downcase
    authorised_action(EDIT,params[:controller], model) ? link_to('Edit', "/#{name.pluralize}/#{model.id}/edit", class: LINK_STYLE) : ""
  end

  def link_delete(model)
    authorised_action(DELETE,params[:controller], model) ? link_to('Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger btn-sm" ) : ""
  end
  
  def link_refresh(name)
    authorised_action(REFRESH,params[:controller],nil) ? link_to("Refresh #{name.titleize.pluralize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
  end
  
  def link_logoutin
    return '' if request.fullpath == '/login'
    session[:user_id] ? link_to('Logout','/logout') : link_to('Login', '/login')
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
      else
        allow_access = session[:admin]
    end
    
    allow_access
  end
  
  def authorised_status_change(action,order)
    user = User.find(session[:user_id])
    
    case action
      when 'draft'
        return false if !order.submitted?
        return true if order.creator == user || order.approver == user
      when 'submit'
        return false if !order.draft? && !order.approved?
        return false if !order.items.any?
        return true if order.draft? && order.creator == user
        return true if order.approved? && order.approver == user
        return true if order.approved? && user.processor?
      when 'approve'
        return false if !order.submitted?
        return true if order.approver == user
      when 'complete'
        return false if !order.approved?
        return true if user.processor?      
    end
    
    false
  end
  
  private
  
  def authorise_orders(user,action,order)  
    case action
      when NEW
        allow_access = user.creator
      when EDIT, DELETE
        allow_access = 
          !order.processed? && 
          change_draft(user,order) &&
          change_submitted(user,order) &&
          change_approved(user,order)
        when PRINT
          allow_access = order.approved? || order.processed?
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
          change_approved(user,order)
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
    return false if !user.processor
    true
  end
  
  def authorise_draft(user,action,order)
    return true if !order.submitted?
    return false if order.creator != user
    true
  end
end


