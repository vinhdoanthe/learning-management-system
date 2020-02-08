Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :user do
    resources :op_students, only: [:index, :new]
  end
end
