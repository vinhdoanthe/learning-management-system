$('document').ready(function () {
	$('#student_batch_progress_li').on('click',function(event){
		var batch_id = $('#student_batch_progress_li').data('batch-id');
		$.ajax({
			type: 'GET',
			data: {
				batch_id: batch_id
			},
			url: '/user/open_educat/op_student/batch_progress',
			dataType: 'script'
		});
	});

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
