function set_file_name(fname) {
  if ( fname == '' ) {
    fname = 'No file selected';
  }
  $('#file_name').val(fname.split(/[\\/]/).pop());
}