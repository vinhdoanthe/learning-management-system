$('document').ready(function () {

	var batch_id = $('#student_batch_progress_li').data('batch-id');
	$.ajax({
		type: 'GET',
		data: {
			batch_id: batch_id
		},
		url: '/user/open_educat/op_students/batch_progress',
		dataType: 'script'
	});
  $('#student_batch_progress_li').on('click', function(){
    $('#course_description_panel').hide();
  })
  $('#student_projects_li').on('click', function(){
    $('#course_description_panel').hide();
  })
  $('#student_batch_info_li').on('click', function(){
    $('#course_description_panel').show();
  })
})

function showSubjectSessions() {
	subject = $('.student_subject_filter').val();
	if (subject == 'all') {
		$('.student_subject_level').show();
	} else {
		$('.student_subject_level').hide();
		$('.subject_level_' + subject).show();
	}
}
