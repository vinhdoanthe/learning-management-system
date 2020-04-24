function student_table(session_id){
  $.ajax({
    url: '/user/open_educat/session_student?session_id=' + session_id,
    method: 'GET',
    dataType: 'script'
  })
}

$(document).ready(function(){
  session_id = $('input[name="active_session"]').val();
   // batch_id = $('input[name="active_batch"]').val();
  student_table(session_id)

$('#session_control').on('click', '#teacher_checkin_confirm_new', function () {
  teacher = $('input[name="teacher_id"]').val();
  time = new Date()
  session_id = $('input[name="checkin_session_id"]').val()
  
  $.ajax({
    method: 'post',
    url: '/user/open_educat/teacher_checkin',
    data: {'faculty_id': teacher, 'time': time, 'session_id': session_id},
    success: function (res) {
      display_noti(res.error)
    }
  })
})

  $('#session_control').on('click', '#teacher_attendance_new', function(){
    session_id = $('input[name="active_session"]').val();
    $.ajax({
      url: '/learning/subject_lesson?session_id=' + session_id,
      method: 'get',
      dataType: 'script'
    })
  })


  $('#subject_timeline').on('click', '.lesson_timeline', function(){
    $('.lesson_timeline').removeClass('active');
    $(this).addClass('active')
  })

  $('#session_student_info').on('click', '.student_evaluate', function(){
    code = $(this).data('code');
    session_id = $('input[name="active_session_id"]').val();

    $.ajax({
      method: 'GET',
      url: '/user/open_educat/student_evaluate?code=' + code + '&session_id=' + session_id,
      dataType: 'script'

    })
  })

  $('#teacher_attendance_confirm_new').on('click', function () {
        lesson_id = $('input[name="attendance_lesson_id"]:checked').val();
      if (!lesson_id){confirm("Vui lòng điền đầy đủ thông tin trước!"); return }
        session_id = $('input[name="active_session_id"').val()
        data = {'session_id': session_id, 'lesson_id': lesson_id, 'student': []}
        $('.attendance_student').each(function (i, element) {
            student_id = $(this).find($('input[name="attendance"]')).val();
            note = $(this).find($('input[name="teacher_note"]')).val();
            check = false
            if ($(element).find($('input[name="attendance"]:checked')).length > 0) {
                check = true;
            }
            data['student'].push({'student_id': student_id, 'note': note, 'check': check})
        })

        $.ajax({
            method: 'post',
            url: '/user/open_educat/teacher_attendance',
            data: data,
            success: function (res) {
                display_noti(res)
            }
        })
    })
  
  $('.select_active_subject').on('click', function(){
    $('.select_active_subject span').removeClass('active_subject');
    $(this).find('span').addClass('active_subject')
  })
})
