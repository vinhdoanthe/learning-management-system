namespace :social_community do
  namespace :photos do

  end

  namespace :albums do

  end

  namespace :comments do

  end

  namespace :reactions do

  end

  get 'student_dashboard' => 'dashboards#student_dashboard', as: 'student_dashboard'
  get 'teacher_dashboard' => 'dashboards#teacher_dashboard', as: 'teacher_dashboard'

  post 'delete_session_photo' => 'photos#delete_session_photo', as: 'delete_session_photo'
end
