function get_date_month(fullDate) {
  twoDigitMonth = ((fullDate.getMonth().toString().length !== 1) || fullDate.getMonth() == 9) ? (fullDate.getMonth() + 1) : '0' + (fullDate.getMonth() + 1);
  twoDigitDate = (fullDate.getDate().toString().length !== 1) ? fullDate.getDate() : '0' + fullDate.getDate()
  str_date = twoDigitDate + "/" + twoDigitMonth + "/" + fullDate.getFullYear();
  return str_date;
}

$(document).ready(function(){
  var save_date = new Date();
  var used_date = new Date();
  used_date.setDate(used_date.getDate() - used_date.getDay());
  set_date_filter(used_date);
  url = window.location.href.includes('teacher_schedule') ? '/user/open_educat/teaching_schedule_content' : '/user/open_educat/op_students/timetable_content'

function fill_table(save_date) {
  used_date = new Date(save_date.getTime());
  set_date_filter(used_date);
  get_schedule(save_date);
}

  function set_date_filter(idate) {
    idate.setDate(idate.getDate() - idate.getDay() + 1);
    begin_week = get_date_month(idate);

    idate.setDate(idate.getDate() + 6)
    end_week = get_date_month(idate);

    $('.start_time').html(begin_week);
    $('.end_time').html(end_week);

    for (var i = 0; i <= 6; i++) {
      var a = new Date(save_date.getTime());
      a.getDay() == 0 ? a.setDate(a.getDate() + i - 6) : a.setDate(a.getDate() - a.getDay() + i + 1);
      day = get_date_month(a);
      if (i != 6) {
        $('.thu_' + (i + 2).toString()).html('Thứ ' + (i + 2).toString() + '<br/><span>' + day + '</span>')
      } else {
        $('.thu_' + (i + 2).toString()).html('Chủ nhật<br/><span>' + day + '</span>')
      }
    }
  }

  function get_schedule(date) {
    $.ajax({
      method: 'post',
      url: url,
      data: {'date': date},
      success: function (res) {
        $('.schedule_info').remove();
        $.each(res.schedules, function (key, schedule) {
          for (var i = 1; i <= 7; i++) {
            if (schedule[i.toString()]) {
              info = schedule[i.toString()]
              if (info.status == 'cancel'){
                html = '<td class="bg-eaeaea schedule_info close_class">'
              }else{
                html = '<td class="bg-eaeaea schedule_info">'
              }
              if (info.batch_class_online){
                html += '<a href="' + info.href +'" data-placement="top" class="ct-detail ctd-cs3 online_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="hover" data-content="<ul><li><h3>HỌC TRỰC TUYẾN</h3></li><li><span><b>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</b></span></li><li><strong>Học viện: </strong>' + info.company + '</li><li><strong>Môn học: </strong>' + info.course + ' </li><li><strong>Mã lớp: </strong> ' + info.batch + '</li><li><strong>Buổi học: </strong> ' + info.lesson + '</li><li><strong>Giáo viên: ' + info.faculty +'</li><li>Phòng học: ' + info.classroom + '</li></ul>"><span>'
              }else{
                html += '<a href="' + info.href +'" data-placement="top" class="ct-detail ctd-cs3 offline_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="hover" data-content="<ul><li><h3>HỌC TẠI TRUNG TÂM</h3></li><li><span><b>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</b></span></li><li><strong>Học viện: </strong>' + info.company + '</li><li><strong>Môn học: </strong>' + info.course + ' </li><li><strong>Mã lớp: </strong> ' + info.batch + '</li><li><strong>Buổi học: </strong> ' + info.lesson + '</li><li><strong>Giáo viên: ' + info.faculty + '</li><li>Phòng học: ' + info.classroom + '</li></ul>"><span>'
              }

              if (info.status == 'cancel') {
                html += '<img src="/global/images/close.png" alt=""></span><b style="color: #5DC2A7 !important">' + info.start_time + '-' + info.end_time + '</b></br>' + info.name + ' </a></td>'
              } else {
                html += '</span><b style="color: #5DC2A7 !important">' + info.start_time + '-' + info.end_time + '</b></br>' + info.name + ' </a></td>'
              }
            } else {
              html = '<td class="bg-fff schedule_info"></td>'
            }

            $('.' + key).append(html);
          }
        })
        $('[data-toggle="popover"]').popover();
      },
      error: function (res) {
        console.log(res);
      }
    })
  }

  $('.month_teaching_schedule').val((save_date.getMonth() + 1).toString());
  $('.chosen_month').addClass('populated')
  $('.schedule_time_previous').click(function (e) {
    save_date.setDate(save_date.getDate() - 7);
    $('.month_teaching_schedule').val((save_date.getMonth() + 1).toString());
    $('.year_teaching_schedule').html(save_date.getFullYear().toString());
    fill_table(save_date);
  })

  $('.schedule_time_next').click(function (e) {
    save_date.setDate(save_date.getDate() + 7);
    $('.month_teaching_schedule').val((save_date.getMonth() + 1).toString());
    $('.year_teaching_schedule').html(save_date.getFullYear().toString());
    fill_table(save_date);
  })

  $('.month_teaching_schedule').on('change', function () {
    save_date = new Date($('.month_teaching_schedule').val() + '/' + save_date.getDate().toString() + '/' + $('.year_teaching_schedule').html());
    fill_table(save_date);
  })

  $('.schedule_year_previous').on('click', function () {
    save_date.setYear(save_date.getFullYear() - 1);
    $('.year_teaching_schedule').html(save_date.getFullYear().toString())
    fill_table(save_date);
  })

  $('.schedule_year_next').on('click', function () {
    save_date.setYear(save_date.getFullYear() + 1);
    $('.year_teaching_schedule').html(save_date.getFullYear().toString())
    fill_table(save_date);
  })

  if (location.href.includes('timetable')){
    get_schedule(save_date);
  }

if (location.href.includes('teacher_schedule')){
  get_schedule(save_date)
}
})
