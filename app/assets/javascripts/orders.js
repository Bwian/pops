function show_supplier() {
  x = $("#order_supplier_id").val()
  if ( x == '' || x > 0) {
    $("#supplier").hide();
  }
  else {
    $("#supplier").show();
  }
};

function clear_notes() {
  $("#order_notes").val("")
}

function submit_it(action) {
  $.ajax({
    url:  $('form').attr('action') + '/' + action,
    type: "POST",
    data: $('form').serialize()
  });
};

function show_actions(flag) {
  if (flag) {
    $("#action_dropdown").show();
  }  
}

function set_payment_date() {
  $.ajax({
    url:  "payment_date",
    type: "POST",
    data: $('form').serialize()
  });
}

function set_delivery_address() {
  $.ajax({
    url:  "delivery",
    type: "POST",
    data: $('form').serialize()
  });
};
