module User
  module Account
    module UsersHelper
      def get_avatar
        if current_user.is_student?
          get_student_user_avatar current_user
        else
          asset_path('global/images/avatar.svg')
        end
      end

      def get_student_avatar student
        user = User.where(student_id: student.id).first
        get_student_user_avatar user
      end

      def get_student_user_avatar user
        if user.avatar.present? && user.avatar.thumbnail.attached?
          user.avatar.thumbnail
        else
          if user.gender == 'm'
            asset_path('global/images/Group-3.png')
          elsif user.gender == 'f'
            asset_path('global/images/Group-5.png')
          else
            asset_path('global/images/icon-student.png')
          end
        end
      end

      def count_mark_question teacher
        teacher.user_answers.where(state: 'waiting').count.to_s
      end

      # get Menu for User is Teacher
      def get_menus_teacher(fullpath)
        menus = [
          {'path' => user_teacher_info_path, 
           'icon' => 'icon-Setting.png',
           'title' => "#{ t('sidebar.config') }", 
           'right_content' => ''
        },

        {'path' => notification_broadcast_broadcast_notices_path, 
         'icon' => 'Icon-Bell.png',
         'title' => "#{ t('sidebar.noti') }", 
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

          {'path' => user_open_educat_teacher_schedule_path, 
           'icon' => 'ico-TienDoHocTap.png',
           'title' => "#{ t('sidebar.teaching_schedule') }", 
           'right_content' => '<span class="left-badge">' << count_sessions_week('op_faculty').to_s << '</span>'
        },

        # {'path' => user_teacher_class_path, 
        #   'icon' => 'ico-TienDoHocTap.png',
        #   'title' => 'Danh sách lớp học', 
        #   'right_content' => '<span class="left-badge">' << current_user.op_faculty.op_batches.uniq.count.to_s << '</span>'
        # },

        {'path' => user_teacher_class_path, 
         'icon' => 'ico-TienDoHocTap.png',
         'title' => "#{ t('sidebar.class_list') }", 
         'right_content' => '<span class="left-badge">' << current_user.op_faculty.op_batches.uniq.count.to_s << '</span>'
        },

        {'path' => learning_marking_question_path, 
         'icon' => 'ico-BaiTapOnBai.png',
         'title' => "#{ t('sidebar.marking') }", 
         'right_content' => '<span class="left-badge">' << count_mark_question(current_user.op_faculty) << '</span>'
        },
        {'path' => social_community_question_answer_my_threads_path, 
         'icon' => 'ico-BaiTapOnBai.png',
         'title' => "#{ t('sidebar.question_answer') }", 
         'right_content' => '<span class="left-badge"></span>'
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
      
      # get Menu for User is Admin
      def get_menus_admin(fullpath)
        
        # Khoi menu report
        menus = [
          {
            'path' => report_diligent_path,
            'title' => '<li><a class="app-menu__item" href="'<< report_diligent_path << '"><i class="app-menu__icon fa fa-dashboard"></i><span class="app-menu__label">'<< t('report.report_diligent_title') <<'</span></a></li>',
            'title_active' => '<li><a class="app-menu__item active" href="'<< report_diligent_path << '"><i class="app-menu__icon fa fa-dashboard"></i><span class="app-menu__label">'<< t('report.report_diligent_title') <<'</span></a></li>'
          },
          
          {
            'path' => report_diligent_path,
            'title' => '<li><a class="app-menu__item" href="'<< report_diligent_path << '"><i class="app-menu__icon fa fa-dashboard"></i><span class="app-menu__label">'<< t('report.report_study_title') <<'</span></a></li>',
            'title_active' => '<li><a class="app-menu__item active" href="'<< report_diligent_path << '"><i class="app-menu__icon fa fa-dashboard"></i><span class="app-menu__label">'<< t('report.report_study_title') <<'</span></a></li>'
          }

        ]
                
        tag_html = '<ul class="app-menu">'
        
          menus.each do |menu|
        
              if (menu['path'] == fullpath)
                tag_html = tag_html + menu['title_active']
              else
                tag_html = tag_html + menu['title']
              end
          
          end
        
        tag_html = tag_html + '</ul>'
          
      end
      
      def get_menus_admin_lte(fullpath)
                    
        # Khoi menu report
        menus = [
          {
            'path' => report_diligent_path,
            'title' => '<li class="nav-item"><a class="nav-link" href="'<< report_diligent_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_diligent_title') <<'</p></a></li>',
            'title_active' => '<li class="nav-item"><a class="nav-link active" href="'<< report_diligent_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_diligent_title') <<'</p></a></li>'
          },
          
          {
            'path' => report_study_path,
            'title' => '<li class="nav-item"><a class="nav-link" href="'<< report_study_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_study_title') <<'</p></a></li>',
            'title_active' => '<li class="nav-item"><a class="nav-link active" href="'<< report_study_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_study_title') <<'</p></a></li>'
          }
  
        ]
                
        tag_html = '<ul class="nav nav-pills nav-sidebar flex-column nav-flat" data-widget="treeview" role="menu" data-accordion="false">'
        
          menus.each do |menu|
        
              if (menu['path'] == fullpath)
                tag_html = tag_html + menu['title_active']
              else
                tag_html = tag_html + menu['title']
              end
          
          end
        
        tag_html = tag_html + '</ul>'
              
      end
      
    end
  end
end
