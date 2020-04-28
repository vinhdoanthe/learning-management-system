namespace :social_community do
  namespace :photos do

  end

  namespace :albums do
    post 'add_reaction', action: 'add_reaction', as: 'add_reaction'
    post 'add_comment', action: 'add_comment', as: 'add_comment'
  end

  namespace :comments do
  end

  namespace :reactions do
  end

  get 'student_dashboard' => 'dashboards#student_dashboard', as: 'student_dashboard'
  get 'teacher_dashboard' => 'dashboards#teacher_dashboard', as: 'teacher_dashboard'
  get 'student_coming_soon_session' => 'dashboards#student_coming_soon_session'
  get 'albums_with_comments' => 'dashboards#albums_with_comments', as: 'albums_with_comments'
end
