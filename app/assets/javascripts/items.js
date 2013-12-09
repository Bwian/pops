// $('#item_price').on('change',function(){

function gst() {
  $.ajax({
    url: "gst",
    type: "POST",
    data: $('form').serialize()
  });
};

function tax_rate() {
  alert('tax_rate');
  $.ajax({
    url: "tax_rate",
    type: "POST",
    data: $('form').serialize()
  });
};