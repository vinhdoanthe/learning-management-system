$(document).ready(function(){
	$('.album-like-btn').click(function(event){
		alert('Clicked')
		event.preventDefault();
		data = {
			'reaction_type': 1,
			'photo_id': $(event.target).data('album-id')
		};
		console.log(data)
		add_reaction_to_album(data);
	});
});

function add_reaction_to_album(data) {
	$.ajax({
		method: 'POST',
		data: data,
		url: '/social_community/albums/add_reaction',
		dataType: 'script'
	})
}

function add_comment_to_album(data) {
	$.ajax({
		method: 'POST',
		data: data,
		url: '/social_community/albums/add_comment',
		dataType: 'script'
	})
}
