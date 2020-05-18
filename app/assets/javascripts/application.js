//=require jquery
//=require jquery_ujs
//=require layout.js
//=require custom_js/opteacherjs.js
//=require user/open_educat/shared/share.js
//=require custom_js/opteacherjs.js
//=require custom_js/opstudent.js
//=require custom_js/learning.js
//=require rails_admin/custom/ckeditor_ajax.js
//=require jquery.lazyload
//=require bootstrap
//
$(document).ready(function () {
	setTimeout(function () {
		$('.alert').remove();
	}, 3000);
	$('[data-toggle="tooltip"]').tooltip();
	let active_menu = JSON.parse(localStorage.getItem('active_menu'));
	if (active_menu != null){
		$('.activea').removeClass('activea')
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

	$(".notice_collapse").on("hide.bs.collapse", function(){
		$(this).parent().find($('a')).html('Xem thêm')
	});
	$(".notice_collapse").on("show.bs.collapse", function(){
		$(this).parent().find($('.notice_state')).attr('src','/global/images/unread_notice.png')
		$(this).parent().find($('a')).html('Đóng')
	});

	$('.toggle_notice_collapse').on('click', function(){
		$('.notice_collapse').collapse('hide');
		$(this).closest('.notice_collapse').collapse('show');
	})
});

window.onbeforeunload = function (e) {
	localStorage.clear();
	return undefined;
};

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

		var days = (t.hours - t.hours % 24) / 24
        daysSpan.innerHTML = ('0' + days).slice(-2) + 'd';
		hoursSpan.innerHTML = (t.hours % 24) + 'h';
		minutesSpan.innerHTML = ('0' + t.minutes).slice(-2) + 'm';
		secondsSpan.innerHTML = ('0' + t.seconds).slice(-2) + 's';

		if (t.total <= 0) {
			clearInterval(timeinterval);
		}
	}

	updateClock();
	var timeinterval = setInterval(updateClock, 1000);
}

function display_noti(error) {
	html = '<div class="alert alert-' + error.type + '"><a href="#" class="close" data-dismiss="alert">×</a><div id="flash_' + error.type + '">' + error.message + '</div></div>'
	$('#noti-message').html(html);
	setTimeout(function () {
		$('#noti-message').html('');
	}, 3000);
}
