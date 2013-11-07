module ApplicationHelper
  
  LINK_STYLE = "btn btn-primary btn-sm"
  
  # This routine returns html links to be used to show, edit or delete data from a model.
  # It relies on the class being passed in conforming to the rails model naming conventions
  def show_edit_destroy(model)
    name = model.class.name.downcase
    actions = link_to('Show', model)
    if session[:admin]
      actions << ' | '
      actions << link_edit(model)
      actions << ' | '
      actions << link_to('Destroy', model, method: :delete, data: { confirm: 'Are you sure?'})
    end
    actions
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
  
  def index_header(name,columns)
    link = session[:admin] ? link_to("New #{name.titleize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
    header = "<tr><td colspan=\"#{columns - 1}\" class=\"header\">#{name.pluralize.titleize}</td><td align=\"right\" class=\"header\">#{link}</td></tr><tr><td></td></tr>"
    header.html_safe
  end
  
  def legend(name,disabled)
    disabled ? name : "Enter #{name}"
  end

  def log_link
    return '' if request.fullpath == '/login'
    session[:user_id] ? link_to('Logout','/logout') : link_to('Login', '/login')
  end
end


