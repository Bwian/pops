function set_gst() {
  $.ajax({
    url:  "gst",
    type: "POST",
    data: $('form').serialize()
  });
};

function tax_rate() {
  var selectize = $('#item_tax_rate_id')[0].selectize;
  $.ajax({
    url:  'tax_rate',
    type: "POST",
    dataType: 'text',
    data: $('form').serialize(),
    success: function(data) {
      selectize.setValue(data,false);
    }
  });
};

function account_select() {
  var selectize = $('#item_account_id')[0].selectize;
  selectize.clearOptions();
  
  $.ajax({
    url:  'account_select',
    type: "POST",
    dataType: 'json',
    data: $('form').serialize(),
    success: function(data) {
      selectize.addOption(data);
      selectize.open();
    }
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