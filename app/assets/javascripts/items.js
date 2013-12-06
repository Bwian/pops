// $('#item_price').on('change',function(){

function gst() {
  $.ajax({
    url: "gst",
    type: "POST",
    data: $('form').serialize()
  });
};