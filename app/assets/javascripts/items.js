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

function program_select() {
  var selectize = $('#item_program_id')[0].selectize;
  selectize.clearOptions();
  
  $.ajax({
    url:  'program_select',
    type: "POST",
    dataType: 'json',
    data: $('form').serialize(),
    success: function(data) {
      selectize.addOption(data);
      selectize.open();
    }
  });
};