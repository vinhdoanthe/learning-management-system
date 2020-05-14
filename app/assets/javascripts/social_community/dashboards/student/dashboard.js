// JavaScript code for Student Dasboard

// $("img").lazyload();

// On page loaded: call to get feed content
$(document).ready(function(){
	get_feeds();
  get_feed_content();
	get_noti_content();
	get_new_user();
  get_attendance_report();
})

function get_feeds() {
  console.log('Start load feeds')
  $.ajax({
    method: 'GET',
    url: '/social_community/home_feeds',
    dataType: 'script'
  })
}

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

function get_attendance_report() {
  $.ajax({
    method: 'GET',
    url: '/user/open_educat/op_students/attendance_report',
    dataType: 'script'
  })
}
