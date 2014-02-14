module ApplicationHelper
  
  LINK_STYLE = "btn btn-primary btn-sm"
  
  def link_list(model)
    name = model.class.name.downcase
    link_to("List #{name.titleize.pluralize}", "/#{name.pluralize}", class: LINK_STYLE)
  end
  
  def link_model(model)
    name = model.class.name.camelcase
    link_to(name, model, class: LINK_STYLE)
  end
  
  def link_new(name)
    session[:admin] ? link_to("New #{name.titleize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
  end
  
  def link_edit(model)
    name = model.class.name.downcase
    session[:admin] ? link_to('Edit', "/#{name.pluralize}/#{model.id}/edit", class: LINK_STYLE) : ""
  end

  def link_delete(model)
    session[:admin] ? link_to('Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger btn-sm" ) : ""
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
end


