function setDefaultDatePicker(target, month_value){
  var d = new Date();
  date = new Date(d.setMonth(d.getMonth() + month_value));
  $(target).datepicker('autoHide', true).datepicker('setDate', date);
}

function setDateRangePicker(target){
  $(target).daterangepicker({
    autoUpdateInput: false,
    locale: {
      format: 'DD/MM/YYYY'
    }
  });

  $(target).on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
  });

  $(target).on('cancel.daterangepicker', function(ev, picker) {
    $(this).val('');
  });

}

function setTimeFormat(time, value){
  day = time.getDate();
  month = time.getMonth() + value;
  year = time.getFullYear();

  return `${ day }/${ month }/${ year }`
}

$('#select_course').select2({ });
$('#select_batch').select2({ });
$('#select_company').select2({ });
$('#select_admission_mode').select2({ });
$(document).ready(function(){
  setDateRangePicker('input[name="start_reserve"]');
})
$('#agree-check').on("change", function(){
  if ($('#agree-check').is(':checked')){
    $('#submit-claim-form').prop('disabled', false);
  }
  if (!$('#agree-check').is(':checked')){
    $('#submit-claim-form').prop('disabled', true);
  }
})

$('#claim-rule-button').on('click', function(){
  html2canvas($(`#claim-form-content`)[0], {scrollY: -window.scrollY, scrollX: -window.scrollX}).then(canvas => {
    href = canvas.toDataURL();
    $('input[name="claim_form_img"]').val(href)
  });
})
