$('document').ready(function () {
	$('#student_batch_progress_li').on('click',function(event){
		var batch_id = $('#student_batch_progress_li').data('batch-id');
		$.ajax({
			type: 'GET',
			data: {
			batch_id: batch_id
			},
			url: '/user/open_educat/batch_progress',
			dataType: 'script'
		});
	});
})
