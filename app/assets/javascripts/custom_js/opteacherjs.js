$(document).ready(function () {

    $('#date_range_pick_form').addClass('populated');

    // Filter class
    function call_api(data) {
        $.ajax({
            type: "POST",
            url: "/user/teacher_class",
            data: data,
            success: function (response) {
                $.each(response.data, function (i, batch) {
                    if (batch.status == true) {
                        $('#batch_list').append("<tr class='batch_info'><td><a href='/user/teacher_class_detail?batch_id=" + batch.id + "'>" + batch.code + "</a></td><td>" + batch.name + " </td><td>" + batch.student_count + "</td><td>" + batch.start_date + " - " + batch.end_date + "</td><td>" + batch.progress + "</td><td align='right'><span class='label-edit label label-primary'>Đang diễn ra</span></td></tr>")
                    } else {
                        $('#batch_list').append("<tr class='batch_info'><td><a href='/user/teacher_class_detail?batch_id=" + batch.id + "'>" + batch.code + "</td><td>" + batch.name + " </td><td>" + batch.student_count + "</td><td>" + batch.start_date + " - " + batch.end_date + "</td><td>" + batch.progress + "</td><td align='right'><span class='label-edit label label-stop'>Đã hoàn thành</span></td></tr>")
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
    $('#daterange_pick').on('apply.daterangepicker', function (ev, picker) {
        start_date = picker.startDate.format('YYYY-MM-DD');
        end_date = picker.endDate.format('YYYY-MM-DD');
        data.start_date = start_date;
        data.end_date = end_date;
        $('.batch_info').remove();
        call_api(data);
    });

    $('#filter_type').on('change', function () {
        active = $('#filter_type').val();
        $('.batch_info').remove();
        data.active = active;
        call_api(data);
    });

    $('#filter_company').on('change', function () {
        company = $('#filter_company').val();
        $('.batch_info').remove();
        data.company = company;
        call_api(data);
    });


    // Teacher class detail
    function change_time(str_time) {
        t = new Date(str_time);
        data = {
            hour: t.getHours().toString(),
            min: t.getMinutes().toString(),
            year: t.getFullYear().toString(),
            month: (t.getMonth() + 1).toString(),
            day: t.getDate().toString(),
            wday: t.getDay()
        }
        return data;
    }

    var months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
    var week_days = ["Chủ Nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];

    function change_view(res, data) {
      if (res.no_session){
        $('#teacher_class_detail_content').html('<h3>Không có buổi học nào của bạn</h3>');
        return
      }
        $('#student_attendance').html('');

        if (res.lesson) {
            $('#lesson_title').html("<strong>" + res.lesson.name + "</strong><br/>" + res.session.name + "<br/>Kiến thức học được: " + res.lesson.note);
            $('.learning_device_content').html(res.lesson.learning_devices);
        }else{
            $('#lesson_title').html("<strong>BÀI: " + "</strong><br/>" + res.session.name + "<br/>Kiến thức học được: " );
            $('.learning_device_content').html('Không có learning device');
        }

        $('.lesson_thumbnail').attr('src', res.img_src)
        start_time = change_time(res.session.start_datetime);
        end_time = change_time(res.session.end_datetime);

        if (res.session.state == 'confirm') {
            $('#teacher_checkin').prop('disabled', false);
        } else {
            $('#teacher_checkin').prop('disabled', true);
        }
        if (res.session.state == 'confirm' || res.session.state == 'done') {
            $('#teacher_attendance').prop('disabled', false);
            $('#upload_session_photo').prop('disabled', false);
        } else {
            $('#teacher_attendance').prop('disabled', true);
            $('#upload_session_photo').prop('disabled', true);
        }
        
      $('.teacher_class_detail_subject').html('Học phần ' + res.subject.level);
        $('.lesson_info').html("<h3>Học phần " + res.subject.level + " - Buổi học: " + (parseInt(res.session_index) + 1).toString() + "</h3><p>" + start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min + " | " + start_time.day + "/" + start_time.month + "/" + start_time.year + "</p>")

        month = months[parseInt(start_time.month) - 1]
        w_day = week_days[start_time.wday]


        $('#calendar-box').html('<div class="cb-tit"><p>' + month + '</p></div><div class="cb-con"><strong>' + start_time.day + '</strong><p>' + start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min + '<br/>' + w_day + '</p></div>')
        $('#session_time_table').html('');

        html_str = "<a type='button' class='btn btn-default btn-embossed' data-toggle='modal' data-target='#modal_materials' data-remote='true' href='/learning/show_google_doc_materials/" + res.session.id + "'> Học liệu </a>"
        $('#btn_view_materials').html('');
        $('#btn_view_materials').html(html_str);


        $.each(res.sessions_time, function (index, time) {
            start = new Date(time[0]);
            end = new Date(time[1]);
            html = '<li><p class="lesson_link"><input type="hidden" name="lesson_id" value="' + index + '"><span class="tag-time">' + (index + 1).toString() + '</span><span class="first-time">' + start.getHours().toString() + ':' + start.getMinutes().toString() + ' - ' + end.getHours().toString() + ':' + end.getMinutes().toString() + '</span><span class="last-time">' + end.getFullYear() + '.' + (end.getMonth() + 1) + '.' + end.getDate() + '</span></p></li>';
            $('#session_time_table').append(html)
            if (index == res.session_index) {
                $('input[name="lesson_id"][value="' + index.toString() + '"]').parent().addClass('active')
            }
        })
        // TO DO: add image for student
      $.each(res.students, function (index, student) {
        if (student.attendance == '') {
          html = '<tr><td>' + student.code + '</td><td><span class="table-img"><img src="' + student.avatar_src + '" alt=""></span><span class="table-name">' + student.name + '<td align="center"><br/>' + student.note.substring(0, 49) + '...</td></span></td>'
        } else if (student.attendance == true) {
          html = '<tr><td>' + student.code + '</td><td><span class="table-img"><img src="' + student.avatar_src + '" alt=""></span><span class="table-name">' + student.name + '<td align="center"><img src="/global/images/check.png" style="width: 20px" alt=""><br/>' + student.note.substring(0, 49) + '...</td></span></td>'
        } else {
          html = '<tr><td>' + student.code + '</td><td><span class="table-img"><img src="' + student.avatar_src + '" alt=""></span><span class="table-name">' + student.name + '<td align="center"><img src="/global/images/remove.png" style="width: 20px" alt=""><br/>' + student.note.substring(0, 49) + '...</td></span></td>'
        }

        switch (student.status) {
          case 'off':
            html += '<td style="text-align: center; opacity: 0.3;"><a><img src="/global/images/add-comment-button.png" style="width: 20px; min-width: 20px;margin-right: 10px"></a></td><td align="right"><span class="label-edit label label-danger">Nghỉ học</span></td></tr>'
            break;
          case 'on':
            html += '<td style="text-align: center"><a class="student_evaluate" data-value="' + index + '" data-toggle="modal" data-target="#modal_evaluate"><img src="/global/images/add-comment-button.png" style="width: 20px; min-width: 20px;margin-right: 10px; cursor: pointer;"></a></td><td align="right"><span class="label-edit label label-primary">Đang học</span></td></tr>'
            break;
          case 'save':
            html += '<td style="text-align: center; opacity: 0.3;"><a><img src="/global/images/add-comment-button.png" style="min-width: 20px; width: 20px; margin-right: 10px"></a></td><td align="right"><span class="label-edit label label-stop">Bảo lưu</span></td></tr>'
            break;
          default:
            null
        }
        $('#student_attendance').append(html)
      })
    }


    function fill_data(data) {
        $.ajax({
            method: 'post',
            url: '/user/teacher_class_detail',
            data: data,
            success: function (res) {
                change_view(res, data);
            }
        })
    }

    var session_index = '';
    var batch_id = $("#batch_id").val();
    var lesson_data = {'session_index': '', 'batch_id': batch_id};
    var subject_id = $(".subject_id.active").find('input[name="subject_id"]').val();

    $('#session_time_table').on('click', '.lesson_link', function (e) {
        e.preventDefault();
        $('.lesson_link').removeClass('active');
        $(this).addClass('active');
        var session_index = $('.lesson_link.active').find('input[name="lesson_id"]').val();
        lesson_data = {'session_index': session_index, 'batch_id': batch_id, 'subject_id': subject_id}
        fill_data(lesson_data);
    })

    if (window.location.href.includes('user/teacher_class_detail')) {
        fill_data(lesson_data);
    }

    $('#subject_id_span').on('click', '.subject_id', function () {
        $('.subject_id').removeClass('active');
        $(this).addClass('active');
        subject_id = $(".subject_id.active").find('input[name="subject_id"]').val();
        lesson_data = {'session_index': session_index, 'batch_id': batch_id, 'subject_id': subject_id}
        fill_data(lesson_data);
    })

    //Teaching schedule calendar
    function get_date_month(fullDate) {
        twoDigitMonth = ((fullDate.getMonth().toString().length !== 1) || fullDate.getMonth() == 9) ? (fullDate.getMonth() + 1) : '0' + (fullDate.getMonth() + 1);
        twoDigitDate = (fullDate.getDate().toString().length !== 1) ? fullDate.getDate() : '0' + fullDate.getDate()
        str_date = twoDigitDate + "/" + twoDigitMonth + "/" + fullDate.getFullYear();
        return str_date;
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

    var save_date = new Date();
    var used_date = new Date();
    used_date.setDate(used_date.getDate() - used_date.getDay());
    set_date_filter(used_date);
    var url = window.location.href.includes('teaching_schedule') ? '/user/teaching_schedule' : '/user/student_timetable'

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
                          html += '<a data-placement="top" class="ct-detail ctd-cs3 online_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="focus" data-content="<ul><li><h3>HỌC TRỰC TUYẾN</h3></li><li><span><b>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</b></span></li><li><strong>Học viện: </strong>' + info.company + '</li><li><strong>Môn học: </strong>' + info.subject + ' - Level ' + info.level + ' </li><li><strong>Khoá học: </strong> ' + info.batch + '</li><li><strong>Lớp: </strong> ' + info.course + '</li><li><strong>Số buổi: </strong> ' + info.lesson + '</li></ul>"><span>'
                        }else{
                          html += '<a data-placement="top" class="ct-detail ctd-cs3 offline_class schedule_link" tabindex="0" role="button" data-html="true" data-toggle="popover" data-trigger="focus" data-content="<ul><li><h4>HỌC TẠI TRUNG TÂM</h4></li><li><span><b>' + info.start_time + ' - ' + info.end_time + ' | ' + info.day + '</b></span></li><li><strong>Học viện: </strong>' + info.company + '</li><li><strong>Môn học: </strong>' + info.subject + ' - Level ' + info.level + ' </li><li><strong>Khoá học: </strong> ' + info.batch + '</li><li><strong>Lớp: </strong> ' + info.course + '</li><li><strong>Số buổi: </strong> ' + info.lesson + '</li></ul>"><span>'
                        }

                        if (info.status == 'cancel') {
                          html += '<img src="/global/images/close.png" alt=""></span>' + info.name + ' </a></td>'
                        } else {
                          html += '</span>' + info.name + ' </a></td>'
                        }
                      } else {
                        html = '<td class="bg-fff schedule_info"></td>'
                      }

                        $('.' + key).append(html);
                        $('.schedule_link').click(function (e) {
                            $(this).popover('show');
                        })
                    }
                })
            },
            error: function (res) {
                console.log(res);
            }
        })
    }

    get_schedule(save_date);

    function fill_table(save_date) {
        used_date = new Date(save_date.getTime());
        set_date_filter(used_date);
        get_schedule(save_date);
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

    // Get current active session in view and update hidden modals
    function call_active_session() {
        $.ajax({
            method: 'get',
            url: '/user/teacher_active_session',
            success: function (res) {
                change_checkin_form(res);
                change_attendance_form(res);
                // update_materials(res);
            }
        })
    }

    //Teacher Check-in
    function change_checkin_form(res) {
        $('.checkin_sesion').html((res.session_index + 1).toString());
        $('.checkin_subject').html((res.subject_level).toString());
        start_time = change_time(res.session.start_datetime)
        time = new Date(res.session.start_datetime)
        date = get_date_month(time)
        end_time = change_time(res.session.end_datetime)
        $('.checkin_start').html(start_time.hour + ':' + start_time.min + '  ' + date);
        $('.checkin_end').html(end_time.hour + ':' + end_time.min + '  ' + date);
        $('.checkin_state').html(res.session.state);
        $('input[name="checkin_session_id"]').val(res.session.id)
    }

    $('#teacher_checkin').on('click', function () {
        call_active_session();
    })

    $('#teacher_checkin_confirm').on('click', function () {
        teacher = $('input[name="teacher_id"]').val();
        time = new Date()
        session_id = $('input[name="checkin_session_id"]').val()
        $.ajax({
            method: 'post',
            url: '/user/teacher_checkin',
            data: {'faculty_id': teacher, 'time': time, 'session_id': session_id},
            success: function (res) {
                display_noti(res.error)
            }
        })
    })


    //Teacher attendance
    $('#teacher_attendance').on('click', function () {
        call_active_session();
    })

    function change_attendance_form(res) {
        $('.attendance_student').remove();
      $('.attendance_lesson_info').html('');
        start_time = change_time(res.session.start_datetime);
        end_time = change_time(res.session.end_datetime);
        
      $('.attendance_session_info').html("<h4><strong>Học phần " + res.subject_level + " - Buổi học: " + (parseInt(res.session_index) + 1).toString() + "</strong></h4><p>" + start_time.hour + ":" + start_time.min + " - " + end_time.hour + ":" + end_time.min + " | " + start_time.day + "/" + start_time.month + "/" + start_time.year + "</p>")

      $.each(res.lessons, function (i, lesson){
        html = "<input type='radio' name='attendance_lesson_id' style='margin: 10px' value='" + lesson.id + "'><label for='" + lesson.id + "'>" + lesson.name + "</label></br>"
        $('.attendance_lesson_info').append(html)
      })

      if(res.lessons.length == 1){$('input[name="attendance_lesson_id"').prop('checked', true)}

        $.each(res.students, function (i, student) {
            if (student.status == 'on') {
                html = "<tr class='attendance_student'><td>" + student.name + "</td><td><input type='checkbox' name='attendance' value='" + i.toString() + "'></td><td><input style='width: 100%' type='text' name='teacher_note' placeholder='Ghi chú của giảng viên'></td></tr>"
                $('#attendance_table').append(html)
            }
        })
    }

    $('#teacher_attendance_confirm').on('click', function () {
        lesson_id = $('input[name="attendance_lesson_id"]:checked').val();
      if (!lesson_id){confirm("Vui lòng điền đầy đủ thông tin trước!"); return }
        faculty_id = $('input[name="teacher_id"]').val();
        session_id = $('input[name="checkin_session_id"').val()
        data = {'faculty_id': faculty_id, 'session_id': session_id, 'lesson_id': lesson_id, 'student': []}
        $('.attendance_student').each(function (i, element) {
            student_id = $(this).find($('input[name="attendance"]')).val();
            note = $(this).find($('input[name="teacher_note"]')).val();
            check = false
            if ($(element).find($('input[name="attendance"]:checked')).length > 0) {
                check = true;
            }
            data['student'].push({'student_id': student_id, 'note': note, 'check': check})
        })

        $.ajax({
            method: 'post',
            url: '/user/teacher_attendance',
            data: data,
            success: function (res) {
                display_noti(res)
            }
        })
    })

    function display_noti(error) {
        html = '<div class="alert alert-' + error.type + '"><a href="#" class="close" data-dismiss="alert">×</a><div id="flash_' + error.type + '">' + error.message + '</div></div>'
        $('#noti-message').html(html);
        setTimeout(function () {
            $('#noti-message').html('');
        }, 3000);
    }

    //Upload photo
    function readURL(input) {
        if (input.files) {
            $.each(input.files, function (i, photo) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#photo_review').append('<img class="photo_review" src="' + e.target.result + '" alt="" />');
                }

                reader.readAsDataURL(photo);
            })
        }
    }

    $('#upload_photo_confirm').on('click', function () {
        params = $('#photo_upload_form').serializeArray()
        var formData = new FormData();

        params.forEach(function (p) {
            formData.append(p['name'], p['value'])
        })
        $.each($('#photos_attachment')[0].files, function (i, file) {
            formData.append("photos[]", file);
        })

        $.ajax({
            method: 'POST',
            url: '/add_photo_attachment',
            data: formData,
            contentType: false,
            processData: false,
            success: function (res) {
                display_noti(res)
            }
        })
    })

    $('#upload_photo_confirm').prop('disabled', true)

    $("#photos_attachment").change(function () {
        $('#photo_review').html('');

        if(this.files.length > 0){
            $('#upload_photo_confirm').prop('disabled', false)
        }else{
            $('#upload_photo_confirm').prop('disabled', true)
        }
        readURL(this);

    });

    $('#upload_session_photo').on('click', function () {
        $('#photo_review').html('')
    })

    $('#upload_photo_confirm').on('click', function () {
        $('#upload_photo').modal('hide')
    });

    //Teacher evaluate
    var student_id = ''
    $('#table_student').on('click', '.student_evaluate', function () {
        student_id = $(this).data('value');
      session_id = $($('#teacher_evaluate_session').find('input[name="session_id"]')).val()
      $.ajax({
        method: 'POST',
        url: '/user/teacher_evaluate_content/',
        data: { student_id: student_id, session_id: session_id },
        success: function (res) {
          debugger
          if (res != 'null' && res != undefined){
          $('select[name="knowledge1"').val(res.knowledge1);
          $('select[name="knowledge2"').val(res.knowledge2);
          $('select[name="knowledge3"').val(res.knowledge3);
          $('select[name="knowledge4"').val(res.knowledge4);
          $('select[name="skill1"').val(res.skill1);
          $('select[name="skill2"').val(res.skill2);
          $('select[name="attitude1"').val(res.attitude1);
          $('select[name="attitude2"').val(res.attitude2);
          $('select[name="attitude3"').val(res.attitude3);
          $('textarea[name="teacher_note"]').html(res.note);
          }
        }
      })
    })

    $('#teacher_evaluate_confirm').on('click', function () {
        info = $('#teacher_evaluate_session').serializeArray();
        info.push({name: 'student_id', value: student_id})
        $.ajax({
            url: '/user/teacher_evaluate',
            method: 'POST',
            data: info,
            success: function (res) {
                display_noti(res);
            }
        })
    })
})

