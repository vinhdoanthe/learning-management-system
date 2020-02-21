Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'user/home#dashboard'
  namespace :user do
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    get 'parent_selection' => 'sessions#new_parent_selection'
    post 'parent_selection' => 'sessions#create_parent_selection'
    get 'logout' => 'sessions#destroy'
    delete 'logout'  => 'sessions#destroy'
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
  end
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
