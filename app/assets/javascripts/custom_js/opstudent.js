
function showSubjectSessions(){
	subject = $('.student_subject_filter').val();
	$('.student_subject_level').hide();
	$('.subject_level_' + subject).show();
}
