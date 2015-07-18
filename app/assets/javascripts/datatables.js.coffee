jQuery -> 
  $('#accounts').dataTable()
  $('#paymentterms').dataTable()
  $('#programs').dataTable()
  $('#suppliers').dataTable()
  $('#taxrates').dataTable()
  $('#tbrservices').dataTable()
  $('#users').dataTable()
  
  $('#orders').dataTable({
    "order": [[ 0, 'desc' ]]
  })