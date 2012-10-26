$(document).ready(function() {
  $('abbr.timeago').timeago();
  $('.timeselector').datepicker({dateFormat: "yy-mm-dd"});
  $('#filter_button').click(function() {
    $("#filter_toggle").toggle('slow', function() {
    });
  });
});
