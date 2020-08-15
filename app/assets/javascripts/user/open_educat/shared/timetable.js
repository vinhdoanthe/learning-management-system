var url = window.location.href.includes('teacher_schedule') ? '/user/open_educat/teaching_schedule_content' : '/user/open_educat/op_students/timetable_content'

function fillWeekDate(date, begin){
  for (var i = 0; i <= 6; i++) {
    day = moment(date).add(i, 'days').format("DD/MM/YYYY")
    $('.thu_' + (i + 2).toString()).html(DAY_IN_WEEK[i] + '<div class="text-center f12 font-medium">' + day + '</div>');
  }
}

function cb(start, end) {
  begin = moment(start).startOf('isoWeek');
  end = moment(end).endOf('isoWeek');
  $('#reportrange span').html(moment(begin).format('DD/MM/YYYY') + ' - ' + moment(end).format('DD/MM/YYYY'));
  fillWeekDate(begin);
  get_schedule(begin.toDate(), begin);
}

function setDateTime(start, end){
  $('#reportrange').daterangepicker({
    singleDatePicker: true,
    showDropdowns: true,
    minYear: 2014,
    maxYear: (parseInt(moment().format('YYYY'),10) + 10),
    startDate: start,
    endDate: end,
    locale: {
      format: 'MMMM D, YYYY'
    }
}, cb);

cb(start, end);

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
              html = '<td class="bg-7E858E schedule_info close_class">'
            }else{
              html = '<td class="schedule_info">'
            }

            var bg_circle_status = 'bg-EB9138';// 

            if (info.batch_class_online) {
              
              bg_circle_status = 'bg-5DC2A7';

              html += '<a href="' + info.href +'" data-placement="top" class="ct-detail ctd-cs3 online_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="hover" data-content="<ul class=\'data-content-line-height\'><li><h3>'+ LEARNING_IN_ONLINE +'</h3></li><li><span style=\'color-0052C1 font-bold\'>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</span></li><li><strong>' + ACADEMY + ': </strong>' + info.company + '</li><li><strong>' + COURSE + ': </strong>' + info.course + ' </li><li><strong>' + BATCH_CODE + ': </strong> ' + info.batch + '</li><li><strong>' + LESSON + ': </strong> ' + info.lesson + '</li><li><strong>' + FACULTY + ': ' + info.faculty +'</li><li>' + ROOM + ': ' + info.classroom + '</li></ul>">'
            } else {
              html += '<a href="' + info.href +'" data-placement="top" class="ct-detail ctd-cs3 offline_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="hover" data-content="<ul class=\'data-content-line-height\'><li><h3>' + LEARNING_IN_CENTER + '</h3></li><li><span class=\'color-0052C1 font-bold\'>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</span></li><li><strong>' + ACADEMY + ': </strong>' + info.company + '</li><li><strong>' + ROOM + ': </strong>' + info.course + ' </li><li><strong>' + BATCH_CODE + ': </strong> ' + info.batch + '</li><li><strong>' + LESSON+ ': </strong> ' + info.lesson + '</li><li><strong>' + FACULTY + ': ' + info.faculty + '</li><li>' + ROOM + ': ' + info.classroom + '</li></ul>">'
            }

            if (info.status == 'cancel') {
              html += '<div class="box-circle bg-F16357"></div><div class="box-info-schedule"><b style="color: #5DC2A7 !important">' + info.start_time + '-' + info.end_time + '</b></br>' + info.name + '</div></a></td>'
            } else {
              html += '<div class="box-circle ' + bg_circle_status +' "></div><div class="box-info-schedule"><b style="color: #5DC2A7 !important">' + info.start_time + '-' + info.end_time + '</b></br>' + info.name + '</div></a></td>'
            }
          } else {
            html = '<td class="schedule_info"></td>'
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

$(document).ready(function(){
  var start = moment().startOf('isoWeek');
  var end = moment().endOf('isoWeek');
  var save_date = moment();

  setDateTime(start, end);

  $('.schedule_time_previous').on('click', function(){
    save_date = save_date.add(-1, 'weeks');
    start = save_date.startOf('isoWeek');
    end = save_date.endOf('isoWeek');

    setDateTime(start, end);
  })

  $('.schedule_time_next').on('click', function(){
    save_date = save_date.add(1, 'weeks');
    start = save_date.startOf('isoWeek');
    end = save_date.endOf('isoWeek');

    setDateTime(start, end);
  })
})


