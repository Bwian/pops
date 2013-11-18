module OrdersHelper
  def link_item_new(order)
    session[:admin] ? link_to("Add Item", "/orders/#{order.id}/items/new", class: ApplicationHelper::LINK_STYLE) : ""
  end
end
