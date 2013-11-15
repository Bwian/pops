module ApplicationHelper
  
  LINK_STYLE = "btn btn-primary btn-sm"
  
  def link_list(model)
    name = model.class.name.downcase
    link_to('List', "/#{name.pluralize}", class: LINK_STYLE)
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
  
  def link_logoutin
    return '' if request.fullpath == '/login'
    session[:user_id] ? link_to('Logout','/logout') : link_to('Login', '/login')
  end
    
  def index_header(name,columns)
    build_header('New',name,columns)
  end
  
  def index_header_refresh(name,columns)
    build_header('Refresh',name,columns)
  end
  
  def legend(name,disabled)
    disabled ? name : "Enter #{name}"
  end

  def format_date(datetime)
    datetime ? datetime.strftime('%d/%m/%Y') : ''
  end

  private
  
  def build_header(type,name,columns)
    link = session[:admin] ? link_to("#{type} #{name.titleize}", "/#{name.pluralize}/new", class: LINK_STYLE) : ""
    header = "<tr><td colspan=\"#{columns - 1}\" class=\"header\">#{name.pluralize.titleize}</td><td align=\"right\" class=\"header\">#{link}</td></tr><tr><td></td></tr>"
    header.html_safe
  end
end


