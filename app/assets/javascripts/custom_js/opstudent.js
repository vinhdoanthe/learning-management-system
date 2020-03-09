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

    $(document).on('click', '.student_homework_sesison', function(){
        $('#student_homework_videos').trigger('click');
    })

    $(document).on('click', '.student_homework_watch_videos', function(){
        session_id = $(this).data('session')
        window.location.href = '/user/student_homework?session=' + session_id
    })

    // $(document).on('click', '#student_homework_back', function(){
    //     window.location = document.referrer;
    // })
})