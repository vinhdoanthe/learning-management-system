module User
  module UsersHelper

    def get_stage(op_student_id, op_batch_id)
      op_student_course = Learning::Batch::OpStudentCourse.where(student_id: op_student_id, batch_id: op_batch_id).first
      if op_student_course.nil?
        state = '';
      else
        state = op_student_course.state.to_s
      end
      state
    end

    def get_nationality(student_id)
      op_student = OpStudent.find(student_id)
      nationality_name = ''
      unless op_student.nationality.nil?
        nationality = Common::ResCountry.find(op_student.nationality)
        unless nationality.nil?
          nationality_name = nationality.name
        end
      end
      nationality_name
    end

    def get_avatar
      asset_path('global/images/avatar.svg')
    end

    def count_sessions_week reference
      current_user.send(reference).op_sessions.where('start_datetime >= ? AND end_datetime <= ?', Time.now.beginning_of_week, Time.now.end_of_week).count
    end

    def count_homework user
      questions = Learning::Homework::UserQuestion.where(student_id: user.id).pluck(:id)
      questions_count = questions.count

      user_answers_count = Learning::Homework::UserAnswer.where(user_question: questions.uniq, state: ['right','waiting']).count
      (questions_count - user_answers_count).to_s
    end

    def count_mark_question teacher
      teacher.user_answers.where(state: 'waiting').count.to_s
    end

    # Lay so thong bao cua hoc sinh
    def count_notification_student user
      all_noti = Notification::BroadcastNoti.where('expiry_date >= ? ', Time.now)
      read_noti = Notification::BroadcastNotiState.where(user_id: current_user.id, broadcast_notice_id: all_noti.pluck(:id)).count
      return all_noti.count - read_noti 
    end

    # Lay so thong bao cua giao vien
    def count_notification_teacher user
      all_noti = Notification::BroadcastNoti.where('expiry_date >= ? ', Time.now).count
      read_noti = Notification::BroadcastNotiState.where(user_id: current_user.id).count
      return all_noti - read_noti 
    end

    #Lay coin_star_transactions
    def coin_transactions user
      return user.coin_star_transactions
    end

    # Lay trang thai trong khoa hoc cua hoc sinh
    def get_student_batch_status(op_student_id, batch_id)
      status = {}
      status['status'] = get_stage(op_student_id, batch_id)      
      if status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_ON
        status['status_html'] = 'Đang học'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_OFF
        status['status_html'] = 'Nghỉ học'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_SAVE
        status['status_html'] = 'Bảo lưu'
      else
        status['status_html'] = 'Đang cập nhật'
      end
      return status
    end

    # get Menu for User is Teacher
    def get_menus_teacher(fullpath)
      menus = [
        {'path' => user_teacher_info_path, 
         'icon' => 'icon-Setting.png',
         'title' => 'Cấu hình', 
         'right_content' => ''
        },

      {'path' => notification_broadcast_broadcast_notices_path, 
       'icon' => 'Icon-Bell.png',
       'title' => 'Thông báo', 
       'right_content' => '<span class="left-badge">' << count_notification_teacher(current_user).to_s << '</span>'
      }
      ]

      # Khoi menu Config
      tag_html = '<div class="noti-nav">'
      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit m-b-0">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active menu_item">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
        else
          tag_html = tag_html + '<li class="nav-active">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
        end

        tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'
      tag_html = tag_html + '</div>'

      # Khoi menu Dashboard
      menus = [
        # {'path' => user_teacher_dashboard_path, 
        #   'icon' => 'ico-Dashboard.png',
        #   'title' => 'Dashboard', 
        #   'right_content' => ''
        # },

        {'path' => user_teaching_schedule_path, 
         'icon' => 'ico-TienDoHocTap.png',
         'title' => 'Lịch giảng dạy', 
         'right_content' => '<span class="left-badge">' << count_sessions_week('op_faculty').to_s << '</span>'
      },

      # {'path' => user_teacher_class_path, 
      #   'icon' => 'ico-TienDoHocTap.png',
      #   'title' => 'Danh sách lớp học', 
      #   'right_content' => '<span class="left-badge">' << current_user.op_faculty.op_batches.uniq.count.to_s << '</span>'
      # },

      {'path' => user_teacher_class_path, 
       'icon' => 'ico-TienDoHocTap.png',
       'title' => 'Danh sách lớp học', 
       'right_content' => '<span class="left-badge">' << current_user.op_faculty.op_batches.uniq.count.to_s << '</span>'
      },

      {'path' => learning_marking_question_path, 
       'icon' => 'ico-BaiTapOnBai.png',
       'title' => 'Chấm bài', 
       'right_content' => '<span class="left-badge">' << count_mark_question(current_user.op_faculty) << '</span>'
      },
      ]


      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit nav-sidebar-bottom">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active menu_item">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        else
          tag_html = tag_html + '<li class="">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        end

        tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      return tag_html

    end

    # get Menu for User is Student
    def get_menus_student(fullpath)
      menus = [
        {'path' => user_student_info_path, 
         'icon' => 'icon-Setting.png',
         'title' => 'Cấu hình', 
         'right_content' => ''
      },

      {'path' => notification_broadcast_broadcast_notices_path, 
       'icon' => 'Icon-Bell.png',
       'title' => 'Thông báo', 
       'right_content' => '<span class="left-badge">' << count_notification_student(current_user).to_s << '</span>'
      }
      ]

      # Khoi menu Config
      tag_html = '<div class="noti-nav">'
      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit m-b-0">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active menu_item activea">'
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="0">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
        else
          tag_html = tag_html + '<li class="nav-active menu_item">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="0">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
        end

        tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'


        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      tag_html = tag_html + '</div>'

      # Khoi menu Dashboard
      menus = [
        # {'path' => user_student_dashboard_path, 
        #   'icon' => 'ico-Dashboard.png',
        #   'title' => 'Dashboard', 
        #   'right_content' => ''
        # },


        {
          'path' =>  user_my_class_path,
          'icon' => 'Icon-Inbox.png',
          'title' => 'Lớp học của tôi',
          'right_content' => '<span class="left-badge">' << current_user.op_student.op_batches.count.to_s << '</span>'
        },

        {'path' => user_student_timetable_path, 
         'icon' => 'ico-TienDoHocTap.png',
         'title' => 'Thời khoá biểu', 
         'right_content' => '<span class="left-badge">' << count_sessions_week('op_student').to_s << '</span>'
        },
        {'path' => user_student_homework_path,
         'icon' => 'ico-BaiTapOnBai.png',
         'title' => 'Bài tập & Ôn bài',
         'right_content' => '<span class="left-badge">' << count_homework(current_user) << '</span>'
        }

        # {'path' => '#', 
        #   'icon' => 'ico-Certificate.png',
        #   'title' => 'Chứng chỉ', 
        #   'right_content' => ''
        # },

        #  {'path' => user_student_product_path, 
        #   'icon' => 'ico-SPhocsinh.png',
        #   'title' => 'Sản phẩm của tôi', 
        #   'right_content' => ''
        #  },

        # {'path' => '#', 
        #   'icon' => 'ico-SPhocsinh.png',
        #   'title' => 'Top thành tích', 
        #   'right_content' => ''
        # }

      ]


      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit nav-sidebar-bottom">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active menu_item activea">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="1">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        else
          tag_html = tag_html + '<li class="menu_item">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="1">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        end

        tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      # Khoi menu Diem thuong
      menus = [
        # {'path' => '#', 
        #   'icon' => 'ico-Certificate.png',
        #   'title' => 'Huy hiệu', 
        #   'right_content' => ''
        # },

        # {'path' => user_student_redeem_path, 
        #   'icon' => 'ico-Redem.png',
        #   'title' => 'Đổi điểm lấy quà', 
        #   'right_content' => ''
        # },

        # {'path' => '#', 
        #   'icon' => 'ico-Redem.png',
        #   'title' => 'Giới thiệu phụ huynh', 
        #   'right_content' => ''
        # },

        # {'path' => user_student_invoice_path, 
        #   'icon' => 'ico-Invoice.png',
        #   'title' => 'Hóa đơn', 
        #   'right_content' => ''
        # },             

      ]

      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit nav-sidebar-bottom">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active menu_item activea">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="1">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        else
          tag_html = tag_html + '<li class="menu_item">'        
          tag_html = tag_html + '<a href="' + menu['path'] + '" data-index="1">'
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] + "", class: "img-changes")
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
        end

        tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      return tag_html
    end

  end
end
