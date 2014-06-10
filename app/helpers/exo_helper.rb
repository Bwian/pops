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
    if field == 'tax_rate_id'
      select(:account, field, TaxRate.selection, {}, { class: "btn btn-primary btn-select" })
    else
      f.text_field(field)
    end
  end
  
end
