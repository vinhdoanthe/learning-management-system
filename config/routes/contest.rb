namespace :contest do
  get '/:id/home', to: 'contests#index'
  namespace :contests do
    get "submit_contest", action: "submit_the_contest", as: "submit_contest"
  end

  resource :contest_projects do
    post "submit_contest_project", action: "submit_contest_project"
  end
end

