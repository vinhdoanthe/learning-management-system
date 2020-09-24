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
        Learning::Homework::UserAnswer.joins(user_question: :question).where(faculty_id: teacher.id, state: 'waiting').where.not(questions: { id: nil }).count.to_s
      end

      # get Menu for User is Teacher
      def get_menus_teacher(fullpath)
        menus = [
          {'path' => user_open_educat_teacher_info_path,
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
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
          else
            tag_html = tag_html + '<li class="nav-active">'        
            tag_html = tag_html + '<a href="' + menu['path'] + '">'
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
          end

          tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

          tag_html = tag_html + '</a>'
          tag_html = tag_html + '</li>'
        end

        tag_html = tag_html + '</ul>'
        tag_html = tag_html + '</div>'

        # Khoi menu Dashboard
        menus = [
          {
            'path' =>  root_path,
            'icon' => 'ico-Dashboard.png',
            'title' => "#{ t('sidebar.dashboard') }",
            'right_content' => '<span class="left-badge"></span>'
          },
          {'path' => user_open_educat_teacher_schedule_path, 
           'icon' => 'calendar.png',
           'title' => "#{ t('sidebar.teaching_schedule') }", 
           'right_content' => '<span class="left-badge">' << count_sessions_week('op_faculty').to_s << '</span>'
          },
          {'path' => user_open_educat_teacher_class_path, 
           'icon' => 'ico-TienDoHocTap.png',
           'title' => "#{ t('sidebar.class_list') }", 
           'right_content' => '<span class="left-badge">' << current_user.op_faculty.op_batches.uniq.count.to_s << '</span>'
          },
          {'path' => learning_marking_question_path, 
           'icon' => 'ico-BaiTapOnBai.png',
           'title' => "#{ t('sidebar.marking') }", 
           'right_content' => '<span class="left-badge">' << count_mark_question(current_user.op_faculty) << '</span>'
          },
          {'path' => coming_soon_page_path, 
           'icon' => 'ico-BaiTapOnBai.png',
           'title' => "#{ t('sidebar.review_student') }", 
           'right_content' => ''
          },
          {'path' => social_community_question_answer_my_threads_path, 
           'icon' => 'Icon-Inbox.png',
           'title' => "#{ t('sidebar.question_answer') }", 
           'right_content' => '<span class="left-badge"></span>'
          },
        ]


        tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit nav-sidebar-bottom" style="border-top: 1px solid #232837; border-bottom: 1px solid #414348; margin: 0">'

        menus.each do |menu|

          if (menu['path'] == fullpath)
            tag_html = tag_html + '<li class="nav-active menu_item">'        
            tag_html = tag_html + '<a href="' + menu['path'] + '">'
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          else
            tag_html = tag_html + '<li class="">'        
            tag_html = tag_html + '<a href="' + menu['path'] + '">'
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          end

          tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

          tag_html = tag_html + '</a>'
          tag_html = tag_html + '</li>'
        end
        tag_html = tag_html + '</ul>'

        # menus for community features
        menus = [
          {'path' => social_community_sc_student_projects_social_student_projects_path, 
            'icon' => 'youtube.png',
            'title' => "#{t('sidebar.my_projects')}", 
            'right_content' => ''
          }
        ]
        tag_html = tag_html + '<ul class="nav nav-sidebar nav-sidebar-edit nav-sidebar-bottom" style="border-top: 1px solid #232837; margin: 0">'
        menus.each do |menu|

          if (menu['path'] == fullpath)
            tag_html = tag_html + '<li class="nav-active menu_item">'        
            tag_html = tag_html + '<a href="' + menu['path'] + '">'
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          else
            tag_html = tag_html + '<li class="">'        
            tag_html = tag_html + '<a href="' + menu['path'] + '">'
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-changes")
            tag_html = tag_html + image_tag("global/images/active/" + menu['icon'] + "", class: "img-change-color")
          end

          tag_html = tag_html + '<span>' + menu['title'].concat(menu['right_content']) + '</span>'

          tag_html = tag_html + '</a>'
          tag_html = tag_html + '</li>'
        end
        tag_html = tag_html + '</ul>'
        tag_html = tag_html + '</div>'

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

      # Menu for Theme Admin lte
      def get_menus_admin_lte(fullpath)

        if current_user.is_admin?
          # Khoi menu report
          sub_menus = {
            'teaching' => [
              {
                'path'          => report_teaching_checkin_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< report_teaching_checkin_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('report.report_teaching_checkin_title') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< report_teaching_checkin_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('report.report_teaching_checkin_title') <<'</p></a></li>',
              },              
            ],
            'learning_activity_management' => [
              {
                'path'          => adm_learning_activity_homework_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_homework_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_homework') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_homework_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_homework') <<'</p></a></li>',
              },
              {
                'path'          => adm_learning_activity_question_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_question_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_question') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_question_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_question') <<'</p></a></li>',
              },
              {
                'path'          => adm_learning_activity_project_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_project_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_project') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_project_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_project') <<'</p></a></li>',
              },              
            ],
            'setting' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.setting.coin_star') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.setting.coin_star') <<'</p></a></li>',
              } 
            ],
            'batch' => [
              {
                'path'          => adm_learning_operation_attendance_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_operation_attendance_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_operation_attendance') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_operation_attendance_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_operation_attendance') <<'</p></a></li>',
              },              
              {
                'path'          => adm_learning_attendance_line_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_attendance_line_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_attendance_line') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_attendance_line_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_attendance_line') <<'</p></a></li>',
              },              
            ],
            'course' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.course') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.course') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.slide_lesson') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.slide_lesson') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.video') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.video') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.homework') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.course.homework') <<'</p></a></li>',
              } 
            ],

            'community' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.post') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.post') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.album') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.album') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.photo') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.photo') <<'</p></a></li>',
              } 
            ],
            'redeem' => [
              {
                'path'          => adm_redeem_redeem_product_brands_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="' + adm_redeem_redeem_product_brands_path + '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_brands') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_product_brands_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_brands') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_product_categories_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_product_categories_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_categories') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_categories') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_product_colors_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_product_colors_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_colors') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_product_colors_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_colors') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_product_sizes_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_product_sizes_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_sizes') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_product_sizes_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_sizes') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_products_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_products_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.products') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_products_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.products') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_product_items_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_product_items_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_items') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_product_items_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.product_items') <<'</p></a></li>',
              },
              {
                'path'          => adm_redeem_redeem_transactions_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'+adm_redeem_redeem_transactions_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.redeem') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'+adm_redeem_redeem_transactions_path+'"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.redeem') <<'</p></a></li>',
              } 
            ],
            'learning_activity' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.discussion') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.discussion') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.homework') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.homework') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.project') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.project') <<'</p></a></li>',
              } 
            ],
          }

          menus = [
            {
              'path'          => report_diligent_path,
              'title'         => '<li class="nav-item"><a class="nav-link" href="'<< report_diligent_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_diligent_title') <<'</p></a></li>',
              'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< report_diligent_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_diligent_title') <<'</p></a></li>'
            },

            {
              'path'          => report_teaching_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_teaching_title') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('report.report_teaching_title') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['teaching']
            },

            {
              'path'          => adm_learning_activity_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity_management') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity_management') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['learning_activity_management']
            },

            {
              'path'          => adm_learning_class_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.class.management_class') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.class.management_class') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['batch']
            },

            {
              'path'          => adm_learning_course_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="'<< adm_learning_course_path << '"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.course.management_course') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="'<< adm_learning_course_path << '"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.course.management_course') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => []
            },

            {
              'path'          => adm_user_index_path,
              'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_user_index_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.user.name') <<'</p></a></li>',
              'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_user_index_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.user.name') <<'</p></a></li>'
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.setting.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.setting.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['setting']
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.course.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.course.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['course']
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.community.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.community.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['community']
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.notice') <<'</p></a></li>',
              'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.notice') <<'</p></a></li>'
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.redeem.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.redeem.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['redeem']
            },

            {
              'path'          => root_path,
              'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.refer_friend') <<'</p></a></li>',
              'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.refer_friend') <<'</p></a></li>'
            },

            #{
            #  'path'          => root_path,
            #  'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #  'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
             # 'sub_menu'      => sub_menus['learning_activity']
            #}
          ]

          tag_html = '<ul class="nav nav-pills nav-sidebar flex-column text-sm nav-flat" data-widget="treeview" role="menu" data-accordion="false">'

          menus.each do |menu|

            if (menu['path'] == fullpath)
              tag_html = tag_html + menu['title_active']
            else
              tag_html = tag_html + menu['title']
            end

            if (!menu['sub_menu'].nil?)
              tag_html = tag_html + '<ul class="nav nav-treeview">'
              menu['sub_menu'].each do |sub_menu|
                if (sub_menu['path'] == fullpath)
                  tag_html = tag_html + sub_menu['title_active']
                else
                  tag_html = tag_html + sub_menu['title']
                end
              end
              tag_html = tag_html + '</ul>'
              tag_html = tag_html + '</li>'
            end

          end

          tag_html = tag_html + '</ul>'
        elsif current_user.is_operation_admin?
          sub_menus = {
            'teaching' => [
              {
                'path'          => report_teaching_checkin_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< report_teaching_checkin_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('report.report_teaching_checkin_title') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< report_teaching_checkin_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('report.report_teaching_checkin_title') <<'</p></a></li>',
              },              
            ],
            'learning_activity_management' => [
              {
                'path'          => adm_learning_activity_homework_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_homework_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_homework') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_homework_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_homework') <<'</p></a></li>',
              },
              {
                'path'          => adm_learning_activity_question_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_question_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_question') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_question_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_question') <<'</p></a></li>',
              },
              {
                'path'          => adm_learning_activity_project_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_activity_project_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_project') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_activity_project_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity_management_project') <<'</p></a></li>',
              },              
            ],
            'batch' => [
              {
                'path'          => adm_learning_operation_attendance_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_operation_attendance_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_operation_attendance') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_operation_attendance_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_operation_attendance') <<'</p></a></li>',
              },              
              {
                'path'          => adm_learning_attendance_line_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_attendance_line_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_attendance_line') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_attendance_line_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_attendance_line') <<'</p></a></li>',
              },              
              {
                'path'          => adm_learning_sessions_index_path,
                'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_learning_sessions_index_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_management_session') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_learning_attendance_line_path << '"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_management_session') <<'</p></a></li>',
              },
            ],
            'community' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.post') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.post') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.album') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.album') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.photo') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.community.photo') <<'</p></a></li>',
              } 
            ],
            'redeem' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.coin_star') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.coin_star') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.redeem') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.redeem.redeem') <<'</p></a></li>',
              } 
            ],
            'learning_activity' => [
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.discussion') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.discussion') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.homework') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.homework') <<'</p></a></li>',
              },
              {
                'path'          => '#',
                'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.project') <<'</p></a></li>',
                'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="far fa-circle nav-icon"></i><p>'<< t('adm.learning_activity.project') <<'</p></a></li>',
              } 
            ],
          }

          menus = [
            # {
            #   'path'          => root_path,
            #   'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity_management') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.learning_activity_management') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'sub_menu'      => sub_menus['learning_activity_management']
            # },

            {
              'path'          => adm_learning_class_path,
              'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.class.management_class') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.class.management_class') <<'</p><i class="right fas fa-angle-left"></i></a>',
              'sub_menu'      => sub_menus['batch']
            },
            {
              'path'          => adm_user_index_path,
              'title'         => '<li class="nav-item"><a class="nav-link" href="'<< adm_user_index_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.user.name') <<'</p></a></li>',
              'title_active'  => '<li class="nav-item"><a class="nav-link active" href="'<< adm_user_index_path << '"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.user.name') <<'</p></a></li>'
            },
            # {
            #   'path'          => root_path,
            #   'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.community.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.community.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'sub_menu'      => sub_menus['community']
            # },
            # {
            #   'path'          => root_path,
            #   'title'         => '<li class="nav-item has-treeview menu-open"><a class="nav-link" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.redeem.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'title_active'  => '<li class="nav-item has-treeview menu-open"><a class="nav-link active" href="#"><i class="nav-icon fas fa-th"></i><p>'<< t('adm.redeem.name') <<'</p><i class="right fas fa-angle-left"></i></a>',
            #   'sub_menu'      => sub_menus['redeem']
            # },

            # {
            #   'path'          => root_path,
            #   'title'         => '<li class="nav-item"><a class="nav-link" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.refer_friend') <<'</p></a></li>',
            #   'title_active'  => '<li class="nav-item"><a class="nav-link active" href="#"><i class="nav-icon fas fa-chart-pie"></i><p>'<< t('adm.refer_friend') <<'</p></a></li>'
            # },
          ]

          tag_html = '<ul class="nav nav-pills nav-sidebar flex-column text-sm nav-flat" data-widget="treeview" role="menu" data-accordion="false">'

          menus.each do |menu|

            if (menu['path'] == fullpath)
              tag_html = tag_html + menu['title_active']
            else
              tag_html = tag_html + menu['title']
            end

            if (!menu['sub_menu'].nil?)
              tag_html = tag_html + '<ul class="nav nav-treeview">'
              menu['sub_menu'].each do |sub_menu|
                if (sub_menu['path'] == fullpath)
                  tag_html = tag_html + sub_menu['title_active']
                else
                  tag_html = tag_html + sub_menu['title']
                end
              end
              tag_html = tag_html + '</ul>'
              tag_html = tag_html + '</li>'
            end

          end

          tag_html = tag_html + '</ul>'
        elsif current_user.is_content_admin?
          ''
        end

      end

    end
  end
end
