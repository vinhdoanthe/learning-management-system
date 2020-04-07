//=require jquery
//=require jquery_ujs
//=require layout.js
//=require video
//=require custom_js/opteacherjs.js
//=require custom_js/opstudent.js
//=require custom_js/learning.js
//=require rails_admin/custom/ckeditor_ajax.js

$(document).ready(function () {
	setTimeout(function () {
		$('.alert').remove();
	}, 3000);

	let active_menu = JSON.parse(localStorage.getItem('active_menu'));
	if (active_menu != null){
		menu = $('#sidebar').find('a[href="' + active_menu.href +'"]')
		if (menu.length == 1){
			$(menu[0]).parent().addClass('activea')
		}else
		{
			$(menu[parseInt(active_menu.index)]).parent().addClass('activea')
		}
	}

	$(document).on('click', '.menu_item', function(){
		$(this).addClass('activea')
		href = $($(this).find($('a'))).attr('href')
		index = $($(this).find($('a'))).attr('data-index')
		obj = { 'href': href, 'index': index }
		localStorage.setItem('active_menu', JSON.stringify(obj));
	})

  public_profile_id = $('#public_profile_id').val();
  $('.public_profile').append('<a href="/user/public_profile/' + public_profile_id + '"><b class="color-5DC2A7 public_profile">Public Profile</b></a>')

  $(window).unload(function(){
    localStorage.removeItem('active_menu');
  });
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

