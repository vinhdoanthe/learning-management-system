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
    post 'reset_password' => 'sessions#reset_password'
    get 'information' => 'users#information'
    get 'teacher_info' => 'op_teachers#teacher_info'
    get 'my_class' => 'users#my_class'

    resources :users
    resources :op_students, only: [:index, :new]
  end
end
