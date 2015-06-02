module ExoHelper
  
  def link_exo(model)
    return '' unless model
    name = model.class.name.underscore.pluralize
    authorised_action(EDIT,params[:controller], model) ? link_to(model.id, url_for(controller: name, id: model.id, action: :edit), class: 'link_exo') : model.id
  end
  
  # These exo_ methods could probably be DRYed
  
  def exo_status(model)
    "'##{model.class.name.underscore}_status'".html_safe
  end
  
  def exo_tax_rate(model)
    "'##{model.class.name.underscore}_tax_rate_id'".html_safe
  end
  
  def exo_payment_term(model)
    "'##{model.class.name.underscore}_payment_term_id'".html_safe
  end
  
  def attribute_label(field)
    label = label_tag field
    label.sub('</',':</').html_safe
  end
  
  def attribute_field(f,field)
    if field =~ /_id$/
      class_name = field.sub('_id','').camelize
      klass = Object.const_get(class_name)
      select = f.select field, klass.selection, { include_blank: true }, {}
      "<div class='select-wide'> #{select} </div>".html_safe
    else
      f.text_field(field)
    end
  end
  
end
