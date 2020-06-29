namespace :adm do
  namespace :learning do
    get 'activity_homework' => 'activity#homework'
    get 'activity_question' => 'activity#question'
    get 'activity_project'  => 'activity#project'
  end
end