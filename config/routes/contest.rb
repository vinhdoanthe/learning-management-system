namespace :contest do
  get '/:id/home', to: 'contests#index'
  get '/:id/new_project', to: 'contests#new', as: 'new_project'
  get '/:contest_id/award', to: 'contests#award', as: 'award'
  get '/:contest_id/contest_projects', to: 'contest_projects#contest_projects'

  namespace :contests do
    get "submit_contest", action: "submit_the_contest", as: "submit_contest"
    get 'new', action: 'new'
    get 'leader_board', action: 'leader_board', as: 'leader_board'
  end

  namespace :contest_projects do
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
