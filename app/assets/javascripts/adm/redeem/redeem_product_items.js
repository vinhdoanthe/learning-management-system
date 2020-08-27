$(document).ready(function(){
let setDateTime = (target) => {
  $(target).daterangepicker({
      timePicker: true,
      autoUpdateInput: false,
      timePickerIncrement: 30,
      locale: {
        format: 'DD/MM/YYYY hh:mm A'
      }   
    })      
    $('#filter-time').on('apply.daterangepicker', function(ev, picker) {
      $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
    });
    
    $('#filter-time').on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
    }); 
}

setDateTime('#filter-input-date');
setDateTime('#filter-release-date');
$('#filter-state').select2();
$('#filter-products').select2();
})
