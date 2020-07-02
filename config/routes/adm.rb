namespace :adm do
  namespace :learning do
    match "/activity_homework" => "activity#homework", via: [:get, :post]
	get 'activity_question' => 'activity#question'
    get 'activity_project'  => 'activity#project'
  end
end