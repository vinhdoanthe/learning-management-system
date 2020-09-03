namespace :social_community do
  resources :user_custom_post_contents, :only => [:create]

  namespace :albums do
    post 'add_reaction', action: 'add_reaction', as: 'add_reaction'
    post 'add_comment', action: 'add_comment', as: 'add_comment'
  end

  namespace :feed do
    namespace :posts do 
      post 'add_reaction', action: 'add_reaction', as: 'add_reaction'
      post 'add_comment', action: 'add_comment', as: 'add_comment'
    end
  end

  namespace :feed do
    resources :posts
    get 'my_posts' => 'posts#index', as: 'my_posts'
    get 'get_reactions_and_comments' => 'posts#get_reactions_and_comments', as: 'get_reactions_and_comments'
  end

  namespace :sc_student_projects do
    get 'social_student_projects', action: 'social_student_projects', as: 'social_student_projects'
    get 'social_student_projects_content', action: 'social_student_projects_content', as: 'social_student_projects_content'
    get 'course_student_projects/:course_id', action: 'course_student_projects', as: 'course_student_projects'
    get 'prepare_upload_project', action: 'prepare_upload_project', as:'prepare_upload_project'
    post 'create_student_project', action: 'create_student_project', as: 'create_student_project'
  end

  namespace :question_answer do
    resources :threads
    get 'my_threads' => 'threads#my_threads', as: 'my_threads'
    resources :messages
  end

  # resources :refer_friends
  namespace :refer_friends do
    get '', action: 'index'
    post 'create_new_refer_request', action: 'create_new_refer_request', as: 'create_new_refer_request'
    put 'confirm/:refer_key', action: 'confirm'
    get 'confirm/:refer_key', action: 'confirm', as: 'confirm'
    put 'discard/:refer_key', action: 'discard'
    get 'discard/:refer_key', action: 'discard', as: 'discard'
    post 'cancel', action: 'cancel', as: 'cancel'
    post 'approve', action: 'approve', as: 'approve'
    post 'update_refer_request', action: 'update_refer_request', as: 'update_refer_request'
  end

  get 'student_project_detail' => 'sc_student_projects#student_project_detail'
  get 'student_projects' => 'sc_student_projects#student_projects'
  get 'teacher_student_projects' => 'sc_student_projects#teacher_student_projects'
  get 'edit_student_project' => 'sc_student_projects#edit_student_project'
  post 'update_student_project' => 'sc_student_projects#update_student_project'
  post 'delete_student_project' => 'sc_student_projects#delete_student_project'

  get 'home_feeds' => 'dashboards#home_feeds', as: 'home_feeds'
  get 'new_feeds' => 'dashboards#new_feeds', as: 'new_feeds'
  get 'student_dashboard' => 'dashboards#student_dashboard', as: 'student_dashboard'
  get 'teacher_dashboard' => 'dashboards#teacher_dashboard', as: 'teacher_dashboard'
  get 'student_coming_soon_session' => 'dashboards#student_coming_soon_session'
  get 'teacher_coming_soon_sessions' => 'dashboards#teacher_coming_soon_sessions'
  get 'albums_with_comments' => 'dashboards#albums_with_comments', as: 'albums_with_comments'
  get 'dashboard_noti' => 'dashboards#dashboard_noti', as: 'dashboard_noti'
  get 'leader_board' => 'dashboards#leader_board', as: 'leader_board'
  get 'leaders' => 'dashboards#leaders', as: 'leaders'
  post 'delete_session_photo' => 'photos#delete_session_photo', as: 'delete_session_photo'
  get 'dashboard_photos' => 'dashboards#dashboard_photos', as: 'dashboard_photos'
end
