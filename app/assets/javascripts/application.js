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
          var utensil_id = resp.utensil.id;
          var utensil_name = resp.utensil.name;
          $('.utensil_select').append($('<option>', { value: utensil_id, text: utensil_name }));
          $('#add_utensil').click(function() {
            $('.utensil_select').append($('<option>', { value: utensil_id, text: utensil_name }));
            $('.utensil_select').reload();
            console.log($('.utensil_select'))
          });
        },
        error: function(resp) {
          alert(resp.responseJSON.utensil_error)
        }
      });
    }
  });
});
