$(document).ready(function(){
	get_teacher_coming_soon_sessions();
	get_noti_content();
  get_checkin_report();
  get_attendance_report();
})

function get_teacher_coming_soon_sessions(){
	$.ajax({
		method: 'GET',
		url: '/social_community/teacher_coming_soon_sessions',
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

function get_checkin_report(){
	$.ajax({
		method: 'GET',
		url: '/user/open_educat/op_teachers/checkin_report',
		dataType: 'script'
	})
}

function get_attendance_report() {
  $.ajax({
    method: 'GET',
    url: '/user/open_educat/op_teachers/attendance_report',
    dataType: 'script'
  })
}
