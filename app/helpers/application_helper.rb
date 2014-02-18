module ApplicationHelper
  
  LINK_STYLE  = "btn btn-primary btn-sm"
  
  # Actions
  NEW         = 'new'
  EDIT        = 'edit'
  DELETE      = 'delete'
  
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
    session[:admin] ? link_to("Refresh #{name.titleize.pluralize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
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
      when 'orders'
        allow_access = authorise_orders(user,action,model)
      when 'items'
        allow_access = authorise_items(user,action,model)
      else
        allow_access = session[:admin]
    end
    
    allow_access
  end
  
  private
  
  def authorise_orders(user,action,order)  
    case action
      when NEW
        allow_access = user.creator
      when EDIT,DELETE
        allow_access = 
          !order.processed? && 
          access_draft(user,order)
      else
        allow_access = true
    end
    
    allow_access
  end
  
  def authorise_items(user,action,model)
    order = model.class.name == 'Item' ? model.order : model
    
    case action
      when NEW,EDIT,DELETE
        allow_access = 
          !order.processed? && 
          access_draft(user,order)
      else
        allow_access = true
    end
    
    allow_access 
  end
  
  def access_draft(user,order)
    return true if !order.draft?
    return false if order.creator != user
    true
  end
end


