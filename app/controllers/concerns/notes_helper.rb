module NotesHelper
  def save_json(name,model)
    name = name.downcase
    key = "#{name}_changes".to_sym
    model ? session[key] = model.to_json : session.delete(key)
  end
  
  def add_notes(name,model)
    name = name.downcase
    key = "#{name}_changes".to_sym
    if name == 'order'
      order_id = model ? model.id : session[key]['id']
    else
      order_id = model ? model.order_id : session[key]['order_id']
    end
    
    order = Order.find(order_id)
    if order.add_notes?
      diff = diff_model(key,model)
      if !diff.empty?
        if model.nil?
          action = 'deleted'
        elsif session[key].nil? || session[key].empty?
          action = 'added'
        else
          action = 'changed'
        end
             
        note = Note.new
        note.order_id = order_id
        note.user_id = session[:user_id]
        note.info = "#{name.capitalize} #{action}:\n #{diff}"
        note.save
      end
    end
    session.delete(key)
  end
  
  def save_notes(params)
    notes = params[:order_notes]
    return if notes.nil?
    
    note = Note.new
    note.order_id = params[:id]
    note.user_id = session[:user_id]
    note.info = notes
    note.save
  end
  
  def diff_model(key,model)
    from = session[key] || {}
    to = model ? model.to_json : {}
    from.delete_if { |key,value| key =~ /id$/ }
    to.delete_if { |key,value| key =~ /id$/ }   
    diff = ''
    
    if from.empty?
      to.each   { |key,value| diff << "- #{key}: #{val_format(value)}\n" }
    elsif to.empty?
      from.each { |key,value| diff << "- #{key}: #{val_format(value)}\n" }
    else
      from.each { |key,value| diff << "- #{key}: #{val_format(value)} to #{val_format(to[key])}\n" if from[key] != to[key] }
    end
    
    diff
  end
  
  private 
  
  def val_format(value)
    rval = "#{value}"
    rval.empty? ? '{empty}' : "\"#{rval}\""
  end
end