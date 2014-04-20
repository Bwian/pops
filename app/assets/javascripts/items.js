function set_gst() {
  $.ajax({
    url:  "gst",
    type: "POST",
    data: $('form').serialize()
  });
};

function tax_rate() {
  $.ajax({
    url:  "tax_rate",
    type: "POST",
    data: $('form').serialize()
  });
};

function account_select() {
  $.ajax({
    url:  "account_select",
    type: "POST",
    data: $('form').serialize()
  });
};