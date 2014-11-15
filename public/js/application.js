$(document).ready(function() {
  // $('.timeselector').datepicker({dateFormat: "yy-mm-dd"});
  $('#filter_button').click(function() {
    $("#filter_toggle").toggle('slow', function() {
    });
  });

  $("#job_description_show_preview").show();
  $("#previewSpan").show();
  
  function toggleLoading() {
    $("#loading-preview").toggle();
    $('#descPreview').toggle();
  }

  $('#job_description_show_preview').click(function(event) {
    event.preventDefault();

    console.log("click");

    $.ajax({
      type: "POST",
      url: "/jobs/preview",
      data: { text: $('#job_description').val()},
      beforeSend: function() {
        toggleLoading();
        console.log("before");
      },
      success: function(data) {
        $("#descPreview").html(data);
        toggleLoading();
        console.log(data);
      }, 
      error: function() {
        console.log("error");
      }
    });
  });
});
