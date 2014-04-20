function show_supplier() {
  x = $("#order_supplier_id").val()
  if ( x == '' || x > 0) {
    $("#supplier").hide();
  }
  else {
    $("#supplier").show();
  }
};
