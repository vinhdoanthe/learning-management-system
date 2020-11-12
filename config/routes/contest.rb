namespace :contest do
  get '/:contest_alias/home', to: 'contests#index'
  get '/:contest_alias/new_project', to: 'contests#new', as: 'new_project'
  get '/:contest_alias/award', to: 'contests#award', as: 'award'
  get '/:contest_alias/contest_projects', to: 'contest_projects#contest_projects'
  get '/contest_award/:project_id', to: 'awards#show'

  namespace :contests do
    get "submit_contest", action: "submit_the_contest", as: "submit_contest"
    get 'new', action: 'new'
    get 'leader_board', action: 'leader_board', as: 'leader_board'
    get 'week_award_content', action: 'week_award_content'
  end

  namespace :contest_projects do
    post 'update', action: 'update'
    get 'show/:id', action: 'show'
    post "submit_contest_project", action: "submit_contest_project"
    post "marking_project", action: "marking_project"
    get 'month_projects', action: 'month_projects'
    get 'week_projects', action: 'week_projects'
    get 'project_detail', action: 'project_detail'
    get 'projects_content', action: 'projects_content'
  end

  namespace :contest_topics do
    get 'contest_month_topics', action: 'contest_month_topics'
  end

end

