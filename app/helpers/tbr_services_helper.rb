module TbrServicesHelper
  def format_phone_number(code)
    code[0] == '0' ? "#{code[0,2]}&nbsp;#{code[2,4]}&nbsp;#{code[6,10]}".html_safe : code
  end
end
