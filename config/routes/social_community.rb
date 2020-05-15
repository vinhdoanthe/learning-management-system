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
    get 'my_posts' => 'posts#index', as: 'my_posts'
  end

  get 'home_feeds' => 'dashboards#home_feeds', as: 'home_feeds'
  get 'student_dashboard' => 'dashboards#student_dashboard', as: 'student_dashboard'
  get 'teacher_dashboard' => 'dashboards#teacher_dashboard', as: 'teacher_dashboard'
  get 'student_coming_soon_session' => 'dashboards#student_coming_soon_session'
  get 'teacher_coming_soon_sessions' => 'dashboards#teacher_coming_soon_sessions'
  get 'albums_with_comments' => 'dashboards#albums_with_comments', as: 'albums_with_comments'
  get 'dashboard_noti' => 'dashboards#dashboard_noti', as: 'dashboard_noti'
  get 'new_user' => 'dashboards#new_user', as: 'new_user'

  post 'delete_session_photo' => 'photos#delete_session_photo', as: 'delete_session_photo'
end
