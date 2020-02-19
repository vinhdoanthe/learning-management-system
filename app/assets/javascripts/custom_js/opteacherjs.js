$(document).ready(function(){

	$('#date_range_pick_form').addClass('populated');
	// Filter class
	function call_api(data){
	    $.ajax({
	        type: "POST",
	        url: "/user/teacher_class",
	        data: data,
	        success: function (response){
	          $.each(response.data, function(i, batch){
	            if (batch.status == true){
	                $('#batch_list').append("<tr class='batch_info'><td><a href='/user/teacher_class_detail?batch_id=" + batch.id + "'>"+ batch.code +"</a></td><td>" + batch.name +" </td><td>" + batch.student_count + "</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>" + batch.progress + "</td><td align='right'><span class='label-edit label label-primary'>Đang diễn ra</span></td></tr>")
	            }
	            else {
	                $('#batch_list').append("<tr class='batch_info'><td><a href='/user/teacher_class_detail?batch_id=" + batch.id + "'>"+ batch.code +"</td><td>" + batch.name +" </td><td>" + batch.student_count + "</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>" + batch.progress + "</td><td align='right'><span class='label-edit label label-stop'>Đã hoàn thành</span></td></tr>")
	            }
	          })
	        },

	    })
	}
	var active = $('#filter_type').val();
	var company = $('#filter_company').val();
	var start_date = '';
	var end_date = '';

	data = {
		'active': active,
		'company': company,
		'start_date': start_date,
		'end_date': end_date
	}

	$('#daterange_pick').daterangepicker();
    $('#daterange_pick').on('apply.daterangepicker', function(ev, picker) {
    	start_date = picker.startDate.format('YYYY-MM-DD');
    	end_date = picker.endDate.format('YYYY-MM-DD');
    	data.start_date = start_date;
    	data.end_date = end_date;
    	$('.batch_info').remove();
    	call_api(data);
    });

	$('#filter_type').on('change', function(){
		active = $('#filter_type').val();
		$('.batch_info').remove();
		data.active = active;
		call_api(data);
	});
	$('#filter_company').on('change', function(){
		company = $('#filter_company').val();
		$('.batch_info').remove();
		data.company = company;
		call_api(data);
	});


	// Teacher class detail
	function change_time(str_time){
		t = new Date(str_time);
		data = {
			hour : t.getHours().toString(),
			min : t.getMinutes().toString(),
			year : t.getFullYear().toString(),
			month : (t.getMonth() + 1).toString(),
			day : t.getDate().toString(),
			wday : t.getDay()
		}
		return data;
	}

	var months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
	var week_days = [ "Chủ Nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];

	function change_view(res, data){
		$('#student_attendance').html('');
		$('#lesson_title').html("<strong>BÀI TODO" + "</strong><br/>" + res.session.name + "<br/>Kiến thức học được: TODO");
		start_time = change_time(res.session.start_datetime);
		end_time = change_time(res.session.end_datetime);

		$('.lesson_info').html("<h3>Học phần " + res.subject.level + " - Buổi học: " + (parseInt(res.session_index) + 1).toString()  + "</h3><p>" + start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min + " | " + start_time.day + "/" + start_time.month + "/" + start_time.year + "</p>")
		
		month = months[parseInt(start_time.month) - 1]
		w_day = week_days[start_time.wday]

		$('#calendar-box').html('<div class="cb-tit"><p>'+ month +'</p></div><div class="cb-con"><strong>'+ start_time.day +'</strong><p>'+ start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min +'<br/>'+ w_day +'</p></div>')

		$('#session_time_table').html('');
		$.each(res.sessions_time, function(index, time) {
			start = new Date(time[0]);
			end = new Date(time[1]);
			html = '<li><p class="lesson_link"><input type="hidden" name="lesson_id" value="' + index + '"><span class="tag-time">' + (index + 1).toString() + '</span><span class="first-time">' +  start.getHours().toString() + ':' + start.getMinutes().toString() + ' - ' + end.getHours().toString() + ':' + end.getMinutes().toString() + '</span><span class="last-time">' + end.getFullYear() + '.' + end.getMonth() + '.' + end.getDate() + '</span></p></li>';
			$('#session_time_table').append(html)
			if (index == res.session_index){
				$('input[name="lesson_id"][value="' + index.toString() + '"]').parent().addClass('active')
			}
		})
		// TO DO: add image for student
	    $.each(res.students, function(index, student) {
	    	if (student.attendance == ''){
	        	html = '<tr><td>' + student.code +'</td><td><span class="table-img"><img src="/global/images/Group.png" alt=""></span><span class="table-name">' + student.name + '<td align="center"><br/>' + student.note + '</td></span></td>'
	        }else if (student.attendance == true){
	        	html = '<tr><td>' + student.code +'</td><td><span class="table-img"><img src="/global/images/Group.png" alt=""></span><span class="table-name">' + student.name + '<td align="center"><img src="/global/images/check.png" style="width: 20px" alt=""><br/>' + student.note + '</td></span></td>'
	        }else{
	        	html = '<tr><td>' + student.code +'</td><td><span class="table-img"><img src="/global/images/Group.png" alt=""></span><span class="table-name">' + student.name + '<td align="center"><img src="/global/images/remove.png" style="width: 20px" alt=""><br/>' + student.note + '</td></span></td>'
	        }

	        switch(student.status) {
			  case 'off':
			    html += '<td align="right"><span class="label-edit label label-danger">Nghỉ học</span></td></tr>'
			    break;
			  case 'on':
			    html += '<td align="right"><span class="label-edit label label-primary">Đang học</span></td></tr>'
			    break;
			  case 'save':
			  	html += '<td align="right"><span class="label-edit label label-stop">Bảo lưu</span></td></tr>'
			    break;
			  default:
			    null
			}
    		$('#student_attendance').append(html)
    	})
	}
			    

	function fill_data(data){
		$.ajax({
			method: 'post',
			url: '/user/teacher_class_detail',
			data: data,
			success: function(res){
				change_view(res, data);
			}
		})
	}

	var session_index = '';
	var batch_id = $("#batch_id").val();
	var lesson_data = {'session_index': '', 'batch_id': batch_id};
	var subject_id = $(".subject_id").find('input[name="subject_id"]').val();

	$('#session_time_table').on('click', '.lesson_link', function(e){
		e.preventDefault();
		$('.lesson_link').removeClass('active');
		$(this).addClass('active');
		var session_index = $('.lesson_link.active').find('input[name="lesson_id"]').val();
		lesson_data = {'session_index': session_index, 'batch_id': batch_id, 'subject_id': subject_id}
		fill_data(lesson_data);
	})

	if(window.location.href.includes('user/teacher_class_detail')){
		fill_data(lesson_data);
	}

	$('#subject_id_span').on('click', '.subject_id', function(){
		$('.subject_id').removeClass('active');
		$(this).addClass('active');
		subject_id = $(".subject_id.active").find('input[name="subject_id"]').val();
		lesson_data = {'session_index': session_index, 'batch_id': batch_id, 'subject_id': subject_id}
		fill_data(lesson_data);
	})

	//Teaching schedule calendar
	function get_date_month(fullDate){
	  twoDigitMonth = ((fullDate.getMonth().length+1) === 1)? (fullDate.getMonth()+1) : '0' + (fullDate.getMonth()+1);
	  str_date = fullDate.getDate() + "/" + twoDigitMonth + "/" + fullDate.getFullYear();
	  return str_date;
	}

	function set_date_filter(idate) {
	  idate.setDate(idate.getDate() - idate.getDay() + 1);
	  begin_week = get_date_month(idate);

	  idate.setDate(idate.getDate() + 6)
	  end_week = get_date_month(idate);
	  
	  $('.start_time').html(begin_week);
	  $('.end_time').html(end_week);

	  for(var i = 0; i <= 6; i++) {
			var a = new Date(save_date.getTime());
			a.setDate(a.getDate() - a.getDay() + i + 1);
			day = get_date_month(a);
			if (i != 6){
				$('.thu_' + (i + 2).toString()).html('Thứ ' + (i + 2).toString() +'<br/><span>'+ day +'</span>')
			}else{
				$('.thu_' + (i + 2).toString()).html('Chủ nhật<br/><span>'+ day +'</span>')
			}
		}
	}

	var save_date = new Date();
	var used_date = new Date();
	used_date.setDate(used_date.getDate() - used_date.getDay());
	set_date_filter(used_date);

	function get_teaching_schedule(date){
		$.ajax({
			method: 'post',
			url: '/user/teaching_schedule',
			data: {'date': date},
			success: function(res){
				$('.schedule_info').remove();
				$.each(res.schedules, function(key, schedule){
						for(var i = 1; i <= 7; i++){
							if(schedule[i.toString()]){
								info = schedule[i.toString()]
								html = '<td class="bg-eaeaea schedule_info"><a data-placement="top" class="ct-detail ctd-cs3 schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="focus" data-content="<ul><li><span>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</span></li><li><strong>Học viện: </strong>' + info.company + '</li><li><strong>Môn học: </strong>' + info.subject + ' - Level ' + info.level +' </li><li><strong>Khoá học: </strong> ' + info.batch + '</li><li><strong>Lớp: </strong> ' + info.course + '</li><li><strong>Số buổi: </strong> ' + info.lesson + '</li></ul>"><span></span>'
								if(info.state == 'cancel'){
									html += '<img src="assets/global/images/close.png" alt="">' + info.name + ' </a></td>'
								}else{
									html += info.name + ' </a></td>'
								}
							}else{
								html = '<td class="bg-fff schedule_info"></td>'
							}

							$('.' + key).append(html);
							$('.schedule_link').click(function(e){ 
								$(this).popover('show');
							})
						}
				})
			},
			error: function(res){
				console.log(res);
			}
		})
	}

	get_teaching_schedule(save_date);

	$('.schedule_time_previous').click(function(e){
		save_date.setDate(save_date.getDate() - 7)
		used_date = new Date(save_date.getTime());
		set_date_filter(used_date);
		get_teaching_schedule(save_date);
	})

	$('.schedule_time_next').click(function(e){
		save_date.setDate(save_date.getDate() + 7)
		used_date = new Date(save_date.getTime());
		set_date_filter(used_date);
		get_teaching_schedule(save_date);
	})
})

