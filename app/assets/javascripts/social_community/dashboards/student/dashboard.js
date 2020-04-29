// JavaScript code for Student Dasboard

 // $("img").lazyload();

// On page loaded: call to get feed content
$(document).ready(function(){
	get_feed_content();
  get_noti_content();
  get_new_user()
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

function get_noti_content(){
  $.ajax({
    method: 'GET',
    url: '/social_community/dashboard_noti',
    dataType: 'script'
  })
}

function get_new_user(){
  $.ajax({
    method: 'GET',
    url: '/social_community/new_user',
    dataType: 'script'
  })
}
