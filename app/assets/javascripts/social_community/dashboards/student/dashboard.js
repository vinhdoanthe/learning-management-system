// JavaScript code for Student Dasboard

 // $("img").lazyload();

// On page loaded: call to get feed content
$(document).ready(function(){
	get_feed_content();
})

// Catch events
function get_feed_content(){
	$.ajax({
		method: 'GET',
		url: '/social_community/albums_with_comments',
		dataType: 'script'
	})

	$.ajax({
		method: 'GET',
		url: '/social_community/student_coming_soon_session',
		dataType: 'script'
	})
}
