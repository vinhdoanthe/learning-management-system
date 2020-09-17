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
  companies = $('#filter-company').val();
  student_name = $('#filter-student').val();
  session_state = $('#filter-session-state').val();
  
  return { start_time: start_time, end_time: end_time, company: companies, student_name: student_name, session_state: session_state }
}

let operationAttendance = (id, state, note) =>  {
  $.ajax({
    method: 'POST',
    url: '/adm/learning/operation_attendances/operation_attendane',
    data: { id: id, state: state, note: note },
    success: function(res){
      display_response_noti(res);
    }
  })
}

$(document).ready(function(){
  getSessionStudent(getDataFilter());

  $('#filter_session_student').on('click', function(){
    getSessionStudent(getDataFilter());
  })

  $('#session_student_table').on('blur', '.text-note', function(){
    $(this).parent().find('.p-note').html($(this).val());
    $(this).parent().find('.p-note').show();
    $(this).hide();
    note = $(this).val()
    id = $(this).data('id');

    if ($(this).parent().parent().find('input.operation-attendance').is(':checked')){
      state = true;
    }else{
      state = false;
    }

    operationAttendance(id, state, note);
  });

  $('#session_student_table').on('click', '.td-note', function(e){
    $('.p-note').show();
    $('.text-note').hide();
    $(this).find('p').hide();
    $(this).find('textarea').show();
    $(this).find('textarea').focus();
  })


  $('#session_student_table').on('change', '.operation-attendance', function(){
    if ($(this).is(':checked')){
      state = true;
    }else{
      state = false;
    }

    id = $(this).val();
    note = $(this).parent().find('textarea.text-note').val();
    operationAttendance(id, state, note);
  })
})
