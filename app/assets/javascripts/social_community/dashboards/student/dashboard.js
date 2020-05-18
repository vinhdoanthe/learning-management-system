// JavaScript code for Student Dasboard
// On page loaded: call to get feed content
$(document).ready(function(){
  get_coming_soon_session();
	get_noti_content();
	get_new_user();
  get_attendance_report();
})


// Catch events
function get_coming_soon_session(){
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
