Rails.application.routes.draw do
  root to: 'user/home#dashboard'
  namespace :user do
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    post 'reset_password' => 'sessions#reset_password'
    get 'information' => 'users#information'
    get 'my_class' => 'users#my_class'

    resources :users
    resources :op_students, only: [:index, :new]
  end
end
