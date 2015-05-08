module TbrsHelper
  def link_logs
    link_to("Previous Logs", url_for(action: 'log'), class: ApplicationHelper::LINK_STYLE)
  end
end
