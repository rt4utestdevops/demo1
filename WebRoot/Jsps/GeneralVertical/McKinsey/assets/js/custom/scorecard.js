$(document).ready(function () {
  $("#overall").on("click", ".option", function (event) {
    let selectedOption = $(this).attr('data-value');
    ['option1', 'option2', 'option3', 'option4', 'option5', 'option6'].forEach(function (val, index) {
      if (val == selectedOption) {
        $('#overall-option-details-' + (index + 1)).show();
        $("#overall div[data-value='option" + (index + 1) + "']").addClass('option-active')
      } else {
        $('#overall-option-details-' + (index + 1)).hide()
        $("#overall div[data-value='option" + (index + 1) + "']").removeClass('option-active')
      }
    })
  });
  $("#driver").on("click", ".option", function (event) {
    let selectedOption = $(this).attr('data-value');
    ['option1', 'option2'].forEach(function (val, index) {
      if (val == selectedOption) {
        $('#driver-option-details-' + (index + 1)).show();
        $("#driver div[data-value='option" + (index + 1) + "']").addClass('option-active')
      } else {
        $('#driver-option-details-' + (index + 1)).hide()
        $("#driver div[data-value='option" + (index + 1) + "']").removeClass('option-active')
      }
    })
  });
  $("#vehicle").on("click", ".option", function (event) {
    let selectedOption = $(this).attr('data-value');
    ['option1', 'option2'].forEach(function (val, index) {
      if (val == selectedOption) {
        $('#vehicle-option-details-' + (index + 1)).show();
        $("#vehicle div[data-value='option" + (index + 1) + "']").addClass('option-active')
      } else {
        $('#vehicle-option-details-' + (index + 1)).hide()
        $("#vehicle div[data-value='option" + (index + 1) + "']").removeClass('option-active')
      }
    })
  });

  $('#sc-route-filter-date').datepicker();
  // demo.initGoogleMaps2(document.getElementById('sc-route-map'))
});
