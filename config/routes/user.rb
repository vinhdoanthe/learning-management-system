namespace :user do
  get 'my_coin_star_transactions' => 'reward/coin_star_transactions#my_coin_star_transactions'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'parent_selection' => 'sessions#new_parent_selection'
  post 'parent_selection' => 'sessions#create_parent_selection'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  namespace :account do
    namespace :users do
      get 'change_password', action: 'change_password'
      post 'change_password', action: 'update_password'

      post 'student_update_nickname', action: 'update_nickname'
      get 'change_avatar', action: 'new_avatar'
      post 'update_user_avatar', action: 'update_user_avatar'
      post 'change_avatar', action: 'update_avatar'
    end
    get 'avatars_list' => 'avatars#avatars_list', as: 'avatars_list'
    namespace :avatars do
      get 'show_fullsize', action: 'show_fullsize'
    end
 
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  end

  get 'teacher_info' => 'op_teachers#teacher_info'
  get 'teacher_class' => 'op_teachers#teacher_class'
  post 'teacher_class' => 'op_teachers#teacher_class'
  get 'teaching_schedule' => 'op_teachers#teaching_schedule'
  post 'teaching_schedule' => 'op_teachers#teaching_schedule'
  get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
  post 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
  # get 'student_info' => 'op_students#student_info'
  get 'teacher_active_session' => 'op_teachers#active_session'
  post 'teacher_checkin' => 'op_teachers#teacher_checkin'
  post 'teacher_attendance' => 'op_teachers#teacher_attendance'

  # get 'teacher_dashboard' => 'op_teachers#dashboard'

  resources :users
  # resources :op_students, only: [:index, :new]

  # get 'student_homework' => 'op_students#student_homework'
  # get 'student_product' => 'op_students#student_product'
  # get 'course_products' => 'op_students#course_products'
  # get 'student_product_detail' => 'op_students#student_product_detail'
  # get 'student_redeem' => 'op_students#student_redeem'
  # get 'student_invoice' => 'op_students#student_invoice'
  # get 'student_timetable' => 'op_students#student_timetable'
  get 'student_homework_detail' => 'op_students#student_homework_detail'
  get 'student_videos' => 'op_students#student_videos'
  get 'student_video_subs' => 'op_students#student_video_subs'
  # get 'refer_friend' => 'op_students#refer_friend'
  post 'student_attendance_line' => 'op_students#student_attendance_line'
  # post 'student_timetable' => 'op_students#student_timetable'
  post 'teacher_evaluate' => 'op_teachers#teacher_evaluate'
  post 'teacher_evaluate_content' => 'op_teachers#teacher_evaluate_content'
  get 'student_evaluate_content' => 'op_students#student_attendance_content'
  get 'session_evaluation_content' => 'op_students#session_evaluation'
  get 'student_videos_list' => 'op_students#student_videos_list'

  # get 'student_dashboard' => 'op_students#dashboard'



  namespace :open_educat do
    resource :op_student do
    end

    resource :op_teacher do
      get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    end
  end
end
