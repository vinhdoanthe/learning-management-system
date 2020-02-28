function showSubjectSessions() {
    subject = $('.student_subject_filter').val();
    if (subject == 'all') {
        $('.student_subject_level').show();
    } else {
        $('.student_subject_level').hide();
        $('.subject_level_' + subject).show();
    }
}

$('document').ready(function () {
    $('.student_evaluate_view').on('click', function () {
        debugger
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
})