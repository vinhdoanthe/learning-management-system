Rails.application.routes.draw do
  root to: 'user/home#dashboard'
  namespace :user do
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    resources :users
    resources :op_students, only: [:index, :new]
  end
end
