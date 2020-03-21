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
      # if current_user.avatar.attached?
      #   current_user.avatar.variant(resize_to_limit: [80, 80])
      # else
      # end
    end

    def count_sessions_week reference
      current_user.send(reference).op_sessions.where('start_datetime >= ? AND end_datetime <= ?', Time.now.beginning_of_week, Time.now.end_of_week).count
    end

    def count_homework user
      questions = Learning::LearningRecord::UserQuestion.where(student_id: user.id).pluck(:id)
      questions_count = questions.count

      user_answers_count = Learning::LearningRecord::UserAnswer.where(user_question: questions.uniq, state: ['right','waiting']).count
      questions_count - user_answers_count
    end

		def count_mark_question teacher
			teacher.user_answers.where(state: 'waiting').count	
		end

    def count_notification_student user
      return 0  
    end

    # Lay trang thai trong khoa hoc cua hoc sinh
    def get_student_batch_status(op_student_id, batch_id)
      status = {}
      status['status'] = get_stage(op_student_id, batch_id)      
      if status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_ON
        status['status_html'] = '<span class="scl-success">Đang học</span>'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_OFF
        status['status_html'] = '<span class="scl-danger">Nghỉ học</span>'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_SAVE
        status['status_html'] = '<span class="scl-danger">Bảo lưu</span>'
      else
        status['status_html'] = '<span class="scl-danger">Đang cập nhật</span>'
      end

      return status
    end

    # get Menu for User is Student
    def get_menus_student(fullpath)
      menus = [
              {'path' => user_student_info_path, 
                'icon' => 'icon-Setting.png',
                'title' => 'Cấu hình', 
                'right_content' => ''
              },
              
              {'path' => '#', 
                'icon' => 'Icon-Bell.png',
                'title' => 'Thông báo', 
                'right_content' => '<span style="float: right; color: red">' << count_notification_student(current_user).to_s << '</span>'
              }

            ]

      # Khoi menu Config
      tag_html = '<div class="noti-nav">'
      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit m-b-0">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active activea">'        
          tag_html = tag_html + '<a href="' + menu['path'] +'">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] +"", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] +"", class: "img-changes")
        else
          tag_html = tag_html + '<li class="nav-active">'        
          tag_html = tag_html + '<a href="' + menu['path'] +'">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] +"", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] +"", class: "img-changes")
        end


        tag_html = tag_html + '<span>'+ menu['title'].concat(menu['right_content']) +'</span>'


        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      tag_html = tag_html + '</div>'

      # Khoi menu Dashboard
      menus = [
              {'path' => user_student_dashboard_path, 
                'icon' => 'ico-Dashboard.png',
                'title' => 'Dashboard', 
                'right_content' => ''
              },
              
              {'path' => user_student_homework_path, 
                'icon' => 'ico-BaiTapOnBai.png',
                'title' => 'Bài tập & Ôn bài', 
                'right_content' => ''
              }

            ]


      tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit">'

      menus.each do |menu|

        if (menu['path'] == fullpath)
          tag_html = tag_html + '<li class="nav-active activea">'        
          tag_html = tag_html + '<a href="' + menu['path'] +'">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] +"", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] +"", class: "img-changes")
        else
          tag_html = tag_html + '<li class="">'        
          tag_html = tag_html + '<a href="' + menu['path'] +'">'
          tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] +"", class: "img-change-color")
          tag_html = tag_html + image_tag("global/images/no-active/" + menu['icon'] +"", class: "img-changes")
        end

        tag_html = tag_html + '<span>'+ menu['title'].concat(menu['right_content']) +'</span>'

        tag_html = tag_html + '</a>'
        tag_html = tag_html + '</li>'
      end

      tag_html = tag_html + '</ul>'

      return tag_html
    end

  end
end
