// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap
//= require link_to_add_fields
//= require activestorage
//= require_tree .

$(document).ready(function() {
  var utensils = "";
  $("#create_utensil").click(function(event) {
    var vname = $('#utensil_name').val();
    if (document.URL.indexOf('/recipes/') != -1) {
      event.preventDefault();
      $.ajax({
        url: "/utensils",
        type: "POST",
        data: {
          utensil: {
            name: vname
          }
        },
        success: function(resp) {
          utensils = resp;
          var utensil_id = resp.utensil.id;
          var utensil_name = resp.utensil.name;
          $('.utensil_select').append($('<option>', { value: utensil_id, text: utensil_name }));
        },
        error: function(resp) {
          alert(resp.responseJSON.utensil_error)
        }
      });
    }
  });
  
  /*
  $("#new_utensil").click(function() {
  });
  $('#add_utensil').click(function() {
    $(utensils).each(function(index) {
      var utensil_id = $(this)[index].utensil.id;
      var utensil_name = $(this)[index].utensil.name;
      console.log($('.utensil_select'))
      $('.utensil_select').append($('<option>', { value: utensil_id, text: utensil_name }));
    });
  });*/
});
