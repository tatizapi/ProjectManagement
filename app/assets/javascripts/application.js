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
//= require activestorage
//= require turbolinks
//= require jquery3
//= require_tree .
//= require cable
//= require moment
//= require bootstrap-datetimepicker
//= require Chart.bundle
//= require chartkick
//= require bootstrap-multiselect

//-----> DASHBOARD - _TABS.HTML.ERB
function filter_change() {
    $.ajax({
      url: "dashboard",
      type: "GET",
      data: {"filter": $('#filter option:selected').val()}
      // dataType: 'ktml',
      // success: function(response) {
      //   $(parinte).append("div" + response.user + "span" + response.message + response.time_date)
      // }
    })
}


//-----> DASHBOARD - INDEX.HTML.ERB
//to put scroll at the bottom when chat loads
window.onload = function() {
  $('.scroll-down').scrollTop($('.scroll-down')[0].scrollHeight);
}

//show the top button
window.onscroll = function() {scrollFunction()};
function scrollFunction() {
  if (document.body.scrollTop > 400) {
    document.getElementById("top-button").style.display = "block";
  } else {
    document.getElementById("top-button").style.display = "none";
  }
}

//when clicking the top button, go to the top of the document
function topFunction() {
  document.body.scrollTop = 0;
}


//-----> TICKETS - FORM.HTML.ERB
$(document).on('mouseover', function() {
  $( "#datetimepicker" ).datetimepicker(
    {
      minDate: moment(), //to disable past dates
      format: 'YYYY-MM-DD hh:mm',
      showClear: true,
      useCurrent: false
    }
  );
});


//-----> COMMENTS - _FORM.HTML.ERB
function slide_comment_form_up(ticket_id) {
  var new_comment_id = '#new-comment-' + ticket_id

  if ($(new_comment_id).is(':visible')) {
      $(new_comment_id).slideUp(350);
  }
}
