namespace :adm do
  namespace :learning do
    match "/activity_homework" => "activity#homework", via: [:get, :post]
    get 'activity_get_batch' => 'activity#list_batch'
    get 'activity_question' => 'activity#question'
    get 'activity_project'  => 'activity#project'
    get 'activity' => 'activity#list_batch'
    #Quan ly lop hoc
    get 'class'  => 'batch#list'
    get 'sessions/index' => 'sessions#index'
    post 'sessions/filter_sessions' => 'sessions#filter_sessions'
    get 'sessions/session_photos' => 'sessions#session_photos'
    get 'sessions/session_attendances' => 'sessions#session_attendances'

    #Quan ly khoa hoc
    get 'course' => 'course#index'
    post 'course/filters' => 'course#filters', as: 'course_filters'
    get 'course/show/:course_id' => 'course#show', as: 'course_show'
    get 'course/:course_id/edit' => 'course#edit', as: 'course_edit'
    post 'course/update' => 'course#update', as: 'course_update'
    get 'operation_attendance' => 'operation_attendances#index', as: 'operation_attendance'
    get 'attendance_line' => 'attendance_lines#index', as: 'attendance_line'
  end

  namespace :user do
    get 'all_user' => 'adm_users#all_user'
    get 'index' => 'adm_users#index'
    post 'index' => 'adm_users#index'
    get 'user_info/:id' => 'adm_users#user_info'
    get 'edit_user_info/:id' => 'adm_users#edit_user_info'
    post 'update_user_info' => 'adm_users#update_user_info'
    post 'filter_users' => 'adm_users#filter_users'
    get 'login_as_user/:user_id' => 'adm_users#login_as_user'
  end
end
