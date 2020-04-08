function filter_answer(batch_id, state){
	$.ajax({
			method: "GET",
			url: '/learning/batch_user_answer_list?batch_id=' + batch_id +'&state=' + state,
			dataType: 'script'
		})
}

function get_next_video(video_id, session_id, index){
	$.ajax({
		method: 'GET',
		url: '/learning/video/next_video?video_index=' + video_id + '&session_id=' + session_id + '&index=' + index,
		dataType: 'script'
	})
}

$('document').ready(function(){
	if (window.location.href.includes('marking_question')){
		var active_batch_answer = $('#batch_user_answer_list').val()
    var state = $('#answer_state_filter').val()
		filter_answer(active_batch_answer, state)

		$('#batch_user_answer_list').on('change', function(){
			active_batch_answer = $(this).val()
			filter_answer(active_batch_answer, state)
		})

    $('#answer_state_filter').on('change', function(){
      state = $(this).val();
      filter_answer(active_batch_answer, state)
    })
	}

	$('#homework_tab2').on('click','#previous_video', function(){
		session_id = $('input[name="next_video_session_id"]').val();
		video_id = $('input[name="video_id"]').val();
		get_next_video(video_id, session_id, -1)
	})

	$('#homework_tab2').on('click','#next_video', function(){
		session_id = $('input[name="next_video_session_id"]').val();
		debugger
		video_id = $('input[name="video_id"]').val();
		get_next_video(video_id, session_id, 1)
	})
})
