// JavaScript code for Student Dasboard
// On page loaded: call to get feed content
$(document).ready(function(){
  get_coming_soon_session();
	get_noti_content();
  get_leader_board();
  get_attendance_report();
  // get_teky_coin_star();
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


function get_leader_board(){
  $.ajax({
    method: 'GET',
    url: '/social_community/leader_board',
    dataType: 'script',
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

// function get_teky_coin_star() {
//   $.ajax({
//     method: 'GET',
//     url: '/user/open_educat/op_students/teky_coin_star',
//     dataType: 'script'
//   })
// }
