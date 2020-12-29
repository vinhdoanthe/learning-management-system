namespace :adm do
  delete 'image_attachment/:blob_id', :to => 'image_attachments#delete_image_attachment', as: 'delete_image_attachment',  :defaults => { :format => :json }
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
    get 'sessions/session_info' => 'sessions#session_info'
    get 'sessions/student_attendance_detail' => 'sessions#student_attendance_detail'
    get 'sessions/session_student_homework' => 'sessions#session_student_homework'
    post 'sessions/update_attendance_line' => 'sessions#update_attendance_line'

    #Quan ly khoa hoc
    get 'course' => 'course#index'
    post 'course/filters' => 'course#filters', as: 'course_filters'
    get 'course/show/:course_id' => 'course#show', as: 'course_show'    
    get 'course/list_lesson_by_session' => 'course#get_lesson_by_session', as: 'get_lesson_by_session'
    get 'course/:course_id/edit' => 'course#edit', as: 'course_edit'    
    post 'course/update' => 'course#update', as: 'course_update'
    post 'course/subject/upload' => 'course#subject_upload', as: 'course_subject_upload'

    get 'course/lesson/:lesson_id/show' => 'lesson#show', as: 'course_lesson_show'    
    get 'course/lesson/:lesson_id/edit' => 'lesson#edit', as: 'course_lesson_edit'
    post 'course/lesson/update' => 'lesson#update', as: 'course_lesson_update'

    get 'course/subject/:subject_id/lesson_learning_materials/update' => 'lesson#lesson_learning_materials_update', as: 'course_subject_lesson_learning_materials_update'
    post 'course/subject/lesson_learning_materials/update/process' => 'lesson#lesson_learning_materials_update_process', as: 'course_lesson_learning_materials_update_process'

    get 'course/lesson/learning_materials/:learning_material_id/edit' => 'lesson#learning_material_edit', as: 'course_lesson_learning_materials_edit'    
    
    get 'operation_attendance' => 'operation_attendances#index', as: 'operation_attendance'
    get 'attendance_line' => 'attendance_lines#index', as: 'attendance_line'

    resources :batches
    namespace :batches do
      get '', action: :index
      get 'filter_batches' => 'batches#filter_batches'
    end

    namespace :operation_attendances do
      get '', action: :index
      get 'index_content', action: 'index_content'
      post 'operation_attendane', action: 'operation_attendance'
    end

  end

  namespace :refer_friend do 
    get 'index', action: 'index'
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
    get 'new_user' => 'adm_users#new_user'
    post 'create_user' => 'adm_users#create_user'
    post 'update_user_password' => 'adm_users#update_user_password'
    get 'student_homework' => 'adm_users#student_homework'
  end

  namespace :faqs do
    get 'index', action: 'index', as: 'index'
    get 'show/:question_id', action: 'show', as: 'show'
    post 'update_question', action: 'update_question', as: 'update_question'
    post 'delete_faq', action: 'delete_faq', as: 'delete_faq'
    get 'new', action: 'new', as: 'new'
  end
  namespace :redeem do
    resources :redeem_products
    resources :redeem_product_items
    resources :redeem_product_brands
    resources :redeem_product_categories
    resources :redeem_product_sizes
    resources :redeem_product_colors
    namespace :redeem_transactions do
      get '', action: :index
      get 'show/:id', action: :show, as: 'show'
      post 'cancel/:id', action: :cancel, as: 'cancel'
      post 'approve/:id', action: :approve, as: 'approve'
      post 'complete/:id', action: :complete, as: 'complete'
    end
  end


  namespace :contest do
    get '/topic_list', to: 'contests#topic_list', as: 'topic_list'
    resources :contests
    namespace :contests do
      post 'update_contest', action: 'update_contest', as: 'update_contest'
      post 'delete_contest', action: 'delete_contest', as: 'delete_contest'
    end

    namespace :contest_prizes do
      post 'create_prize', action: 'create_prize'
      get 'prepare_create', action: 'prepare_create'
      get 'contest_prize_detail', action: 'contest_prize_detail'
    end

    resources :contest_topics
    namespace :contest_topics do
      post 'create_topic', action: 'create_topic', as: 'create_topic'
      post 'delete_topic', action: 'delete_topic', as: 'delete_topic'

      get 'new/:contest_id', action: 'show', as: 'show'
      get 'load_data/:contest_id', action: 'load_data', as: 'load_data'
    end

    namespace :contest_criterions do
      post 'create_criterion', action: 'create_criterion', as: 'create_criterion'
      post 'delete_criterion', action: 'delete_criterion', as: 'delete_criterion'
    end

    namespace :contest_projects do
      get '', action: 'index', as: 'index'
      get 'index_content', action: 'index_content', as: 'index_content'
      post 'calculate_point', action: 'calculate_point', as: 'calculate_point'
      post 'award_week_projects', action: 'award_week_projects', as: 'award_week_projects'
      post 'update', action: 'update', as: 'update'
    end

    resources :contest_exchanges
    namespace :contest_exchanges do
      post 'create_new', action: 'create_new', as: 'create_new'
      post 'update', action: 'update', as: 'update'
    end

    namespace :contest_sliders do
      get '', action: 'index'
      get 'slider_detail', action: 'slider_detail'
      post 'remove_slider', action: 'remove_slider'
      post 'update_slider', action: 'update_slider'
    end

    resources :contest_events, only: [:index]
    namespace :contest_events do
      get 'event_detail', action: 'event_detail'
      post 'update_event', action: 'update_event'
      post 'delete_event', action: 'delete_event'
    end
  end
end
