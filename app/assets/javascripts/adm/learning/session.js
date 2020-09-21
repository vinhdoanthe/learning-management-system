function getDataSession(data){
  $.ajax({
    url: '/adm/learning/sessions/filter_sessions',
    method: 'POST',
    data: data,
    dataType: 'script'
  })
}

function getSessionInfo(session_id){
  $.ajax({
    url: '/adm/learning/sessions/session_info?session_id=' + session_id,
    method: 'GET',
    dataType: 'script'
  })
}

function getStudentAttendanceDetail(session_id, attendance_id){
  $.ajax({
    url: '/adm/learning/sessions/student_attendance_detail?session_id=' + session_id + '&attendance_id=' + attendance_id,
    method: 'GET',
    dataType: 'script'
  })
}

function getDataFilter(){
  batch_id = $('#filter-batch').val();
  company = $('#filter-company').val();
  state = $('#filter-state').val();

  if ($('#filter-time').val().length === 0){
    start_time = '';
    end_time = '';
  }else{
    start_time = $('#filter-time').data('daterangepicker').startDate._d;
    end_time = $('#filter-time').data('daterangepicker').endDate._d;
  }
  photo_state = $('input[name="session_photo"]:checked').val();
  attendance = $('input[name="session_attendance_state"]:checked').val()

  return { batch_id: batch_id, company: company, state: state, start_time: start_time, end_time: end_time, photo_state: photo_state, attendance: attendance }
}

let updateTeacherEvaluate = (attendance_id, state, note) => {
  $.ajax({
    method: 'POST',
    url: '/adm/learning/sessions/update_attendance_line',
    data: { attendance_state: state, attendance_id: attendance_id, note: note, authenticity_token: $('[name="csrf-token"]')[0].content},
    success: function(res){
      display_response_noti(res);
    }
  })
}

function getSessionPhotos(session_id) {
  $.ajax({
    url: '/adm/learning/sessions/session_photos?session_id=' + session_id,
    method: 'GET',
    dataType: 'script'
  })
}

$(document).ready(function(){
  var data = getDataFilter();
  data['page'] = 0
  data['index'] = 1
  getDataSession(data);

  
  $('#paginator').on('click', '.previous_page', function () {
    data = getDataFilter();
    data['page'] = $(this).data('page')
    data['index'] = -1;
    getDataSession(data)
  })

  $('#paginator').on('click', '.next_page', function () {
    data = getDataFilter();
    data['page'] = $(this).data('page')
    data['index'] = 1;
    getDataSession(data)
  })

  $('#submit_filter_sessions').on('click', function(){
    data = getDataFilter();
    data['page'] = 0;
    data['index'] = 1;
    getDataSession(data);
  })

  $('#session_data_table').on('click', '.session_photo_modal', function(){
    session_id = $(this).data('session')
    getSessionPhotos(session_id)
  })

  $('#session_data_table').on('click', '.session_attendance_modal', function(){
    session_id = $(this).data('session')
    getSessionInfo(session_id);
  })

  $('#modal_adm_session_attendance').on('click', '.view_attendance_detail', function(){
    session_id = $(this).data('session')
    attendance_id = $(this).data('attendance')
    getStudentAttendanceDetail(session_id, attendance_id);
  })

  $('#modal_adm_session_attendance').on('click', '.back_to_session_info', function(){
    session_id = $('input[name="active_session"]').val();
    getSessionInfo(session_id);
  })

  $('#modal_adm_session_attendance').on('click', '.published_teacher_evaluate', function(){
    attendance_id = $(this).data('att')
    state = $(this).data("state");
    updateTeacherEvaluate(attendance_id, state, '')
  })

  $('#modal_adm_session_attendance').on('keyup', '#operation_note_content', function(){
    if ($(this).val().length > 0){
      $('.confirm_teacher_evaluate').attr('data-dismiss', 'modal');
    }else{
      $('.confirm_teacher_evaluate').removeAttr('data-dismiss');
    }
  })

  $('#modal_adm_session_attendance').on('click', '.confirm_teacher_evaluate', function(){
    attendance_id = $(this).data('att')
    state = $(this).data("state");

    if ($('#operation_note_content').val().length > 0){
      note = $('#operation_note_content').val();
      updateTeacherEvaluate(attendance_id, state, note)
    }else{
      if (!$('#operation_note').is(":hidden")){
        display_response_noti({ type: 'danger', message: "Lý do đánh giá không đạt yêu cầu không được để trống!"})
      }
      $('#operation_note').show();
    }
  })
})
