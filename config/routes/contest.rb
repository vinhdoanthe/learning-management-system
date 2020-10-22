namespace :contest do
  get '/:id/home', to: 'contests#index'
  get '/:id/new_project', to: 'contests#new', as: 'new_project'
  namespace :contests do
    get "submit_contest", action: "submit_the_contest", as: "submit_contest"
    get 'new', action: 'new'
  end

  resource :contest_projects do
    post "submit_contest_project", action: "submit_contest_project"
  end
end

