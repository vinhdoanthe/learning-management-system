namespace :social_community do
  namespace :photos do

  end

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

  namespace :comments do
  end

  namespace :reactions do
  end
  
  namespace :feed do
    resources :posts
    get 'my_posts' => 'posts#index', as: 'my_posts'
    get 'get_reactions_and_comments' => 'posts#get_reactions_and_comments', as: 'get_reactions_and_comments'
  end

  namespace :sc_student_projects do
    get 'social_student_projects', action: 'social_student_projects', as: 'social_student_projects'
    get 'course_student_projects/:course_id', action: 'course_student_projects', as: 'course_student_projects'
  end

    namespace :question_answer do
    resources :threads
    resources :messages
  end

  post 'youtube_upload' => 'sc_student_projects#youtube_upload'
  get 'student_project_detail' => 'sc_student_projects#student_project_detail'
  get 'student_projects' => 'sc_student_projects#student_projects'
  get 'teacher_student_projects' => 'sc_student_projects#teacher_student_projects'
  get 'edit_student_project' => 'sc_student_projects#edit_student_project'
  post 'update_student_project' => 'sc_student_projects#update_student_project'

  get 'home_feeds' => 'dashboards#home_feeds', as: 'home_feeds'
  get 'student_dashboard' => 'dashboards#student_dashboard', as: 'student_dashboard'
  get 'teacher_dashboard' => 'dashboards#teacher_dashboard', as: 'teacher_dashboard'
  get 'student_coming_soon_session' => 'dashboards#student_coming_soon_session'
  get 'teacher_coming_soon_sessions' => 'dashboards#teacher_coming_soon_sessions'
  get 'albums_with_comments' => 'dashboards#albums_with_comments', as: 'albums_with_comments'
  get 'dashboard_noti' => 'dashboards#dashboard_noti', as: 'dashboard_noti'
  get 'leader_board' => 'dashboards#leader_board', as: 'leader_board'
  post 'delete_session_photo' => 'photos#delete_session_photo', as: 'delete_session_photo'
end
