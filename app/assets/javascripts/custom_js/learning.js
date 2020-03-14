function filter_answer(batch_id){
	$.ajax({
			method: "GET",
			url: '/learning/batch_user_answer_list?batch_id=' + batch_id,
			dataType: 'script'
		})
}

$('document').ready(function(){
	if (window.location.href.includes('marking_question')){
		var active_batch_answer = $('#batch_user_answer_list').val()
		filter_answer(active_batch_answer)

		$('#batch_user_answer_list').on('change', function(){
			active_batch_answer = $(this).val()
			filter_answer(active_batch_answer)
		})
	}
})