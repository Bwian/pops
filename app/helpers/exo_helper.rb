module ExoHelper
  
  def link_exo(model)
    return '' unless model
    name = model.class.name.underscore
    authorised_action(EDIT,params[:controller], model) ? link_to(model.id, "/#{name.pluralize}/#{model.id}/edit", class: 'link_exo') : model.id
  end
  
  def attribute_label(field)
    label = label_tag field
    label.sub('</',':</').html_safe
  end
  
  def attribute_field(f,field)
    if field =~ /_id$/
      class_name = field.sub('_id','').camelize
      klass = Object.const_get(class_name)
      f.select field, klass.selection, { include_blank: true }, { class: "btn btn-primary" }
    else
      f.text_field(field)
    end
  end
  
end
