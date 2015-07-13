function set_file_name(fname) {
  if ( fname == '' ) {
    fname = 'No file selected';
  }
  $('#file_name').val(fname.split(/[\\/]/).pop());
}

function set_form_target() {
  if ( $('#report').val() == 'email' ) {
    $('form').attr('target', '_self');
  }
  else {
    $('form').attr('target', '_blank');
  }
}

function report_select() {
  var selectize = $('#report')[0].selectize;
  selectize.clearOptions();
  
  $.ajax({
    url:  'report_select',
    type: "POST",
    dataType: 'json',
    data: $('form').serialize(),
    success: function(data) {
      selectize.addOption(data);
      selectize.setValue(data[0].value);
    }
  });
}
