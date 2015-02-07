module ExoHelper
  
  def link_exo(model)
    return '' unless model
    name = model.class.name.underscore.pluralize
    authorised_action(EDIT,params[:controller], model) ? link_to(model.id, url_for(controller: name, id: model.id, action: :edit), class: 'link_exo') : model.id
  end
  
  def attribute_label(field)
    label = label_tag field
    label.sub('</',':</').html_safe
  end
  
  def attribute_field(f,field)
    if field =~ /_id$/
      class_name = field.sub('_id','').camelize
      klass = Object.const_get(class_name)
      f.select field, klass.selection, { include_blank: true }, { class: "btn btn-primary btn-sm" }
    else
      f.text_field(field)
    end
  end
  
end
