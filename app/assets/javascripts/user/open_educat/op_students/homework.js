function get_video( batch_id, subject_id){
  session_id = $('input[name="active_session"]').val();
    $.ajax({
      method: 'GET',
      url: '/learning/show_video/' + session_id + '?session_id=' + session_id + '&batch_id=' + batch_id + '&subject_id=' + subject_id,
      dataType: 'script',
      success: function(){
        debugger
        $('.video_carousel').owlCarousel({
          margin:10,
          nav:true,
          responsive:{
            0:{
              items:1    
            },
            600:{
              items:3
            },
            1000:{
              items:5
            }
          }
        })

      }
    })
}

function get_homework(data){
  $.ajax({
    url: '/user/open_educat/op_students/student_homework',
    method: 'GET',
    data: data,
    dataType : 'script',
    success: function(){
      select_val = $('#homework_course_selection').val()
      $('.student_course_title').html($('#homework_course_selection option[value="' + select_val.toString() + '"]').html())
      if (typeof session_id !== 'undefined'){
        option = $('#homework_session_table').find('input[value="' + session_id +'"]').parent().find('a')
        if(option){option.trigger('click');}
      }
    }
  })
}

// function filter_learning_params(){

$('document').ready(function () {
  active_batch = $('input[name="active_batch"]').val();
  active_subject = $('input[name="active_subject"]').val();

  $('#homework_tab1').on('click','.student_homework_watch_videos', function(){
    $('input[name="active_session"]').val($(this).data('session'));
    $('input[name="change_video"][value="' + $(this).data('session') + '"]').parent().css('background-color', 'rgba(44, 42, 41, 0)');
    $('#student_homework_videos').trigger('click')
  })

  $('#student_homework_videos').on('click', function(){
    get_video(active_batch, active_subject)
  })

  $('#homework_tab2_new').on('click', '.thumbnail_layer', function(){
    $('.thumbnail_layer').css("background-color", "rgba(44, 42, 41, 0.52)");
    $(this).css('background-color', 'rgba(44, 42, 41, 0)');
    session_id = $(this).find($('input[name="change_video"]')).val()
    $('input[name="active_session"]').val(session_id);
    get_video(active_batch, active_subject)
  })

  $('#homework_course_selection').on('change', function(){
    course = $('#homework_course_selection').val()
    get_homework({course: course})
  })

  $('#homework_batch_selection').on('change', function(){
    course = $('#homework_course_selection').val()
    batch = $('#homework_batch_selection').val() 
    get_homework({course: course, batch: batch})
  })  

  $('#homework_subject_selection').on('change', function(){
    course = $('#homework_course_selection').val()
    batch = $('#homework_batch_selection').val() 
    subject = $('#homework_subject_selection').val()
    get_homework({course: course, batch: batch, subject: subject})
  })

  $('.video_carousel').owlCarousel({
    margin:10,
    nav:true,
    responsive:{
      0:{
        items:1
      },
      600:{
        items:3
      },
      1000:{
        items:5
      }
    }
  })


  var waitingdialog = waitingdialog || (function ($) {
    'use strict';

    // creating modal dialog's dom
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
  })
})
