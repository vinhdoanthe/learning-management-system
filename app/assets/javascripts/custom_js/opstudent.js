function showSubjectSessions() {
    subject = $('.student_subject_filter').val();
    if (subject == 'all') {
        $('.student_subject_level').show();
    } else {
        $('.student_subject_level').hide();
        $('.subject_level_' + subject).show();
    }
}

function get_video(session_id, target) {
    $.ajax({
        url: '/learning/show_video/' + session_id,
        method: 'GET',
        data: {session_id: session_id, target: target}
    })
}

function get_homework(data){
    $.ajax({
        url: '/user/student_homework',
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

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};

$('document').ready(function () {
    $('.student_evaluate_view').on('click', function () {
        sudent_id = $(this).data('student');
        session_id = $(this).data('session');
        $.ajax({
            url: '/user/student_attendance_line',
            method: 'post',
            data: {'student_id': sudent_id, 'session_id': session_id},
            success: function (res) {

            }
        })
    })

    if(window.location.href.includes('student_homework') && (window.location.href.includes('session=') == false)){
        var homework_session = $('input[name="homework_session"]').val()
        get_video(homework_session, 'watch_video_box');
        get_homework();
    }

    if(window.location.href.includes('student_homework?session=')){
        searchParams = new URLSearchParams(window.location.search)
        session_id = searchParams.get('session')
        var homework_session = $('input[name="homework_session"]').val()
        get_video(homework_session, 'watch_video_box');
        get_homework({session: session_id})
    }

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


    $(document).on('click', '.student_homework_watch_videos', function(){
        session_id = $(this).data('session')
        window.location.href = '/user/student_homework?session=' + session_id
    })

    // Student do homework
    if(window.location.href.includes('/learning/view_question')){
        question_id = $('input[name="student_question_id"]').val()
        $.ajax({
            method: 'GET',
            url: '/learning/question_content?user_question_id=' + question_id + '&index=0',
            dataType: 'script',
        })

        var questions_count = $('input[name="questions_count"').val();
        $('#question_id_span').html('1/' + questions_count + ' BÀI')
        $('.question_select').first().addClass('active_question');
        // $('.question_select').first().removeClass('bg-CFCFCF');
        $('.question_select').click(function(){
            $('.question_select').removeClass('active_question');
            // $(this).removeClass('bg-CFCFCF');
            $(this).addClass('active_question');
            $('#question_id_span').html($(this).html() + '/' + questions_count + ' BÀI')
        })

        $('#answer_the_question').on('click', function(){
            question_choices = $("input[name='student_choise_answer']:checked").map(function(){
              return $(this).val();
            }).get()

            if (!question_choices || question_choices.length == 0){
                question_choices = $('#text_answer').val();
            }
            
					$('#modal-basic').html('')
            question = $('#question_id').val();
            user_question = $('#user_question_id').val();
					session_id = getUrlParameter('session_id');

            $.ajax({
                method: 'POST',
                url: '/learning/answer_question',
                data: { session_id: session_id, question: question, question_choices: question_choices, user_question: user_question},
                dataType: 'script'
            })
        })
    }

    $('.student_evaluate_view').on('click', function(){
        $('.student_evaluate_view_content').html('')
    })

    $('#student_videos_list').on('click', '.student_show_video', function(){
        $('#student_videos_list td').removeClass('undone_question')
        $(this).parent().addClass('undone_question')
    })

  if (window.location.href.includes('view_question')){
    session_id = getUrlParameter('session_id');
    $.ajax({
      method: 'GET',
      url: '/learning/get_video_list?session=' + session_id,
      dataType: 'script'
    })

    get_video(session_id, 'watch_video_box');

  }
})
