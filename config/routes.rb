Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'user/home#dashboard'
  namespace :user do
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    get 'parent_selection' => 'sessions#new_parent_selection'
    post 'parent_selection' => 'sessions#create_parent_selection'
    get 'logout' => 'sessions#destroy'
    delete 'logout' => 'sessions#destroy'
    get 'teacher_info' => 'op_teachers#teacher_info'
    get 'my_class' => 'users#my_class'
    get 'batch_detail/:batch_id' => 'users#batch_detail', as: 'batch_detail'
    get 'teacher_class' => 'op_teachers#teacher_class'
    post 'teacher_class' => 'op_teachers#teacher_class'
    get 'teaching_schedule' => 'op_teachers#teaching_schedule'
    post 'teaching_schedule' => 'op_teachers#teaching_schedule'
    get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    post 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    post 'student_update_nickname' => 'users#update_nickname'
    get 'change_password' => 'users#change_password'
    post 'change_password' => 'users#update_password'
    get 'student_info' => 'op_students#student_info'
    get 'teacher_active_session' => 'op_teachers#active_session'
    post 'teacher_checkin' => 'op_teachers#teacher_checkin'
    post 'teacher_attendance' => 'op_teachers#teacher_attendance'
    resources :users
    resources :op_students, only: [:index, :new]

    get 'student_homework' => 'op_students#student_homework'
    get 'student_product' => 'op_students#student_product'
    get 'student_redeem' => 'op_students#student_redeem'
    get 'student_invoice' => 'op_students#student_invoice'
    get 'student_timetable' => 'op_students#student_timetable'
    get 'student_homework_detail' => 'op_students#student_homework_detail'
    get 'student_videos' => 'op_students#student_videos'
    get 'student_video_subs' => 'op_students#student_video_subs'
    get 'refer_friend' => 'op_students#refer_friend'
    post 'student_attendance_line' => 'op_students#student_attendance_line'
    post 'student_timetable' => 'op_students#student_timetable'
    post 'teacher_evaluate' => 'op_teachers#teacher_evaluate'
    get 'student_evaluate_content' => 'op_students#student_attendance_content'
    get 'student_videos_list' => 'op_students#student_videos_list'
  end

  namespace :learning do
    get 'view_learning_material/:material_id' => 'learning_materials#view_learning_material'
    get 'pdf_materials' => 'learning_materials#pdf_materials'
    get 'show_pdf/:session_id' => 'learning_materials#show_pdf', as: 'show_single_pdf'
    get 'show_google_doc_materials/:session_id' => 'learning_materials#show_google_doc_materials', as: 'show_google_doc_materials'
    get 'show_video/:session_id' => 'learning_materials#show_video', as: 'show_single_video'
    get 'view_question' => 'learning_records#view_question'
    get 'question_content' => 'learning_records#question_content'
    post 'answer_question' => 'learning_records#answer_question'

  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  post 'add_photo_attachment' => 'learning/batch/sessions#add_photo_attachment'

  delete 'sign_out', :to => 'user/sessions#destroy', as: 'logout'
end
