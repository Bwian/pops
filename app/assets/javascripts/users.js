function set_ldap_params() {
  $("#notice").text("Retrieving login details ...");
  $.ajax({
    url:  "ldap",
    type: "POST",
    data: $('form').serialize()
  });
};
