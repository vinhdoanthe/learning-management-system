$('document').ready(function(){
	if (window.location.href.includes('marking_question')){
		var active_batch_answer = $('#batch_user_answer_list').val()
		$.ajax({
			method: "GET",
			url: '/learning/batch_user_answer_list?batch_id=' + active_batch_answer,
			dataType: 'script'
		})
	}
})