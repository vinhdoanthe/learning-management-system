let getSessionStudent = (data) => {
  $.ajax({
    url: '/adm/learning/operation_attendances/index_content',
    method: 'GET',
    data: data,
    dataType: 'script'
  })
}

let getDataFilter = () => {
  if ($('#filter-time').val().length === 0){
    start_time = '';
    end_time = '';
  }else{
    start_time = $('#filter-time').data('daterangepicker').startDate._d;
    end_time = $('#filter-time').data('daterangepicker').endDate._d;
  }
  company = $('#filter-company').val();
  student_name = $('#filter-student').val();
  session_state = $('#filter-session-state').val();
  
  return { start_time: start_time, end_time: end_time, company_id: company, student_name: student_name, session_state: session_state }
}
var result = true;
let operationAttendance = (id, state, note) =>  {
  $.ajax({
    method: 'POST',
    url: '/adm/learning/operation_attendances/operation_attendane',
    data: { id: id, state: state, note: note },
    success: function(res){
      display_response_noti(res);
      if (res.type == 'danger'){
        result = false;
      }
    }
  })
}

$(document).ready(function(){
  getSessionStudent(getDataFilter());

  $('#filter_session_student').on('click', function(){
    getSessionStudent(getDataFilter());
  })

  $('#session_student_table').on('click', '.td-note', function(e){
    if (e.target !== $('.fa-check-square')[0] && e.target !== $('.fa-window-close')[0]){
    $('.p-note').show();
    $('.text-div').hide();
    $(this).find('p').hide();
    $(this).find('.text-div').show();
    $(this).find('textarea').focus();
    }
  })

  $("#session_student_table").on('click', '.confirm-update-note', function(){
    id = $(this).data('id');
    note = $(this).closest('td').find('textarea').val();

    if ($(this).closest('td').find('input.operation-attendance').is(':checked')){
      state = true;
    }else{
      state = false;
    }

    operationAttendance(id, state, note);

    if (result){
      $(this).closest('td').find('p').html(note);
      $(this).closest('td').find('p').show();
      $(this).closest('td').find('.text-div').hide();
    }
  })

  $('#session_student_table').on('focusout', '.text-div', function(e){
    let target = $(this)
    window.setTimeout(function() {
      target.hide();
      target.closest('td').find('p').show();
      target.find('textarea').val(target.closest('td').find('p').html());
    }, 200);
  })


  $('#session_student_table').on('change', '.operation-attendance', function(){
    if ($(this).is(':checked')){
      state = true;
      $(this).closest('tr').addClass('att_active');
    }else{
      state = false;
      $(this).closest('tr').removeClass('att_active');
    }

    id = $(this).val();
    note = $(this).parent().find('textarea.text-note').val();
    operationAttendance(id, state, note);
  })
})
