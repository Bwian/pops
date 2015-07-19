// Global javascript functions required by the application framework

// Search for entered order number
function order_search() {
  $.ajax({
    url:  $ROOT_PATH + 'orders/' + $("#order_search").val() +'/search',
    type: "GET"
  });
};

// Needed by the order search field to make IE Enter fire onchange
function check_enter(event) {
	if (event.which == 13) {
		event.srcElement.blur();
	}
};
