function set_file_name(fname) {
  if ( fname == '' ) {
    fname = 'No file selected';
  }
  $('#file_name').val(fname.split(/[\\/]/).pop());
}

function set_report_select() {
  $.ajax({
    url:  "report_select",
    type: "POST",
    data: $('form').serialize()
  });
}