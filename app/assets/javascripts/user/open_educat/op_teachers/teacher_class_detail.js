function student_table(session_id){
  $.ajax({
    url: '/user/open_educat/session_student?session_id=' + session_id,
    method: 'GET',
    dataType: 'script'
  })
}

$(document).ready(function(){

  var waitingdialog = waitingdialog || (function ($) {
    'use strict';
    var $dialog = $(
      '<div class="modal fade" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true" style=" overflow-y:visible;">' +
      '<div class="modal-dialog modal-m">' +
      '<div class="modal-content">' +
      '<div class="modal-header"><h3 style="margin:0;"></h3></div>' +
      '<div class="modal-body">' +
      '<div class="progress progress-striped active" style="margin-bottom:0;"><div class="progress-bar" style="width: 100%"></div></div>' +
      '</div>' +
      '</div></div></div>');

    return {
      show: function (message, options) {
        // Assigning defaults
        if (typeof options === 'undefined') {
          options = {};
        }
        if (typeof message === 'undefined') {
          message = 'Loading';
        }
        var settings = $.extend({
          dialogSize: 'm',
          progressType: '',
          onHide: null // This callback runs after the dialog was hidden
        }, options);

        // Configuring dialog
        $dialog.find('.modal-dialog').attr('class', 'modal-dialog').addClass('modal-' + settings.dialogSize);
        $dialog.find('.progress-bar').attr('class', 'progress-bar');
        if (settings.progressType) {
          $dialog.find('.progress-bar').addClass('progress-bar-' + settings.progressType);
        }
        $dialog.find('h3').text(message);
        // Adding callbacks
        if (typeof settings.onHide === 'function') {
          $dialog.off('hidden.bs.modal').on('hidden.bs.modal', function (e) {
            settings.onHide.call($dialog);
          });
        }
        // Opening dialog
        $dialog.modal();
      },
      hide: function () {
        $dialog.modal('hide');
      }
    };

  })(jQuery);
  session_id = $('input[name="active_session"]').val();
  // batch_id = $('input[name="active_batch"]').val();
  student_table(session_id)

  $('#session_control').on('click', '.icon_reward', function(){
    active = $(this).find($('.active_reward'))
    html = '<span class="active_reward" style=" width: 15px; height: 15px; background-color: #5DC2A7 ; position: absolute; top: 0; right: 0; border-radius: 50%;"></span>'

    if (active.length == 0){
      $(this).append(html)
    }else{
      active.remove()
    }
  });

  $('#session_control').on('click', '.reward_type', function(){
    $('.active_reward_type').removeClass('plus-add');
    $('.active_reward_type').html('0');
    $(this).find($('.active_reward_type')).addClass('plus-add');
    $(this).find($('.active_reward_type')).html('+1')
  })

  $('#session_control').on('click', '#reward_student_confirm', function(){
    students = []
    $(".active_reward").each(function() {
      students.push($(this).parent().find($('input[name="active_reward_student"]')).val())
    })

    reward_type = $('.active_reward_type').parent().find($('input[name="active_reward_type"]')).val()
    $('#reward_student_modal').modal('hide')

    $.ajax({
      method: 'POST',
      url: '/learning/reward_student',
      data: { students: students, reward_type: reward_type, session_id: session_id },
      success: function(res){        
        display_noti(res)
      }
    })
  })

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
  $('#session_control').on('click', '#reward_student', function(){
    waitingdialog.show();
    session_id = $('input[name="active_session"]').val();
    $.ajax({
      method: "GET",
      url: "/learning/op_session/session_reward?session_id=" + session_id,
      dataType: "script",
      success: function(){
        waitingdialog.hide();
      }
    })
  })
})
