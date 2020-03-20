//=require jquery
//=require jquery_ujs
//= require layout.js
//= require video
//=require custom_js/opteacherjs.js
//=require custom_js/opstudent.js
//=require custom_js/learning.js
//=require rails_admin/custom/ckeditor_ajax.js

$(document).ready(function () {
	setTimeout(function () {
		$('.alert').remove();
	}, 3000);
});

function getTimeRemaining(endtime) {
	var t = Date.parse(endtime) - Date.parse(new Date());
	if (t<0) {
		var seconds = 0;
		var minutes = 0;
		var hours = 0;
	} else {
		var seconds = Math.floor((t / 1000) % 60);
		var minutes = Math.floor((t / 1000 / 60) % 60);
		var hours = Math.floor((t / (1000 * 60 * 60)));
	}

	return {
		'total': t,
		'hours': hours,
		'minutes': minutes,
		'seconds': seconds
	};
}

function initializeClock(id, endtime) {
	var clock = document.getElementById(id);
	var daysSpan = clock.querySelector('.days');
	var hoursSpan = clock.querySelector('.hours');
	var minutesSpan = clock.querySelector('.minutes');
	var secondsSpan = clock.querySelector('.seconds');

	function updateClock() {
		var t = getTimeRemaining(endtime);

		days = (t.hours - t.hours % 24) / 24
		$('.days').html(days.toString() + 'd');
		hoursSpan.innerHTML = t.hours % 24 + 'h';
		minutesSpan.innerHTML = ('0' + t.minutes).slice(-2) + 'm';
		secondsSpan.innerHTML = ('0' + t.seconds).slice(-2) + 's';

		if (t.total <= 0) {
			clearInterval(timeinterval);
		}
	}

	updateClock();
	var timeinterval = setInterval(updateClock, 1000);
}
