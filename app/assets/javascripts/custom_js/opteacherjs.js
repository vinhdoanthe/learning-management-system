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
	            if (batch.check_status == true){
	                $('#batch_list').append("<tr class='batch_info'><td>"+ batch.code +"</td><td>" + batch.name +" </td><td>4</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>4/12 - Học phần 1</td><td align='right'><span class='label-edit label label-primary'>Đang diễn ra</span></td></tr>")
	            }
	            else {
	                $('#batch_list').append("<tr class='batch_info'><td>"+ batch.code +"</td><td>" + batch.name +" </td><td>4</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>4/12 - Học phần 1</td><td align='right'><span class='label-edit label label-stop'>Đã hoàn thành</span></td></tr>")
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

	// Teaching schedule
	$('.teaching_schedule').click(function(e){
		e.preventDefault();
		$(this).parent().find($('.schedule_detail')).css('display','block')
	})

	$(document).mouseup(function(e) {
	    var container = $(".schedule_detail");
	    if (!container.is(e.target) && container.has(e.target).length === 0) 
	    {
	        container.hide();
	    }
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
		$('#lesson_title').html("<strong>BÀI " + res.session.timing_id.toString() + "</strong><br/>" + res.session.name + "<br/>Kiến thức học được: TODO");
		start_time = change_time(res.session.start_datetime);
		end_time = change_time(res.session.end_datetime);
		$('.lesson_info').html("<h3>Học phần " + res.subject.level + " - Buổi học: " + (parseInt(data.session_index) + 1).toString()  + "</h3><p>" + start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min + " | " + start_time.day + "/" + start_time.month + "/" + start_time.year + "</p>")
		month = months[parseInt(start_time.month) - 1]
		w_day = week_days[start_time.wday]
		$('#calendar-box').html('<div class="cb-tit"><p>'+ month +'</p></div><div class="cb-con"><strong>'+ start_time.day +'</strong><p>'+ start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min +'<br/>'+ w_day +'</p></div>')

	    for (var i = 0; i < res.students.length; i++) {
	        html = '<tr><td>' + res.students[i].code +'</td><td><span class="table-img"><img src="assets/global/images/Group.png" alt=""></span><span class="table-name">' + res.students[i].name + '<td align="center"><img src="assets/global/images/remove.png" style="width: 20px" alt=""><br/>' + res.students[i].note + '</td></span></td>'
	        switch(res.students[i].status) {
			  case 'cancel':
			    html += '<td align="right"><span class="label-edit label label-danger">Đã huỷ</span></td></tr>'
			    break;
			  case 'done':
			    html += '<td align="right"><span class="label-edit label label-stop">Đã diễn ra</span></td></tr>'
			    break;
			  case 'confirm':
			  	html += '<td align="right"><span class="label-edit label label-primary">Sắp diễn ra</span></td></tr>'
			    break;
			  default:
			    null
			}
    		$('#student_attendance').append(html)
    	}
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

	var session_index = $('.lesson_link.active').find('input[name="lesson_id"]').val();
	var batch_id = $("#batch_id").val();
	var lesson_data = {'session_index': session_index, 'batch_id': batch_id};

	$('.lesson_link').click(function(e){
		e.preventDefault();
		$('.lesson_link').removeClass('active');
		$(this).addClass('active');
		var session_index = $('.lesson_link.active').find('input[name="lesson_id"]').val();
		lesson_data = {'session_index': session_index, 'batch_id': batch_id}
		fill_data(lesson_data);
	})

	fill_data(lesson_data)
})

