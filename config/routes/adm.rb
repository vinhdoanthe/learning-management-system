namespace :adm do
  namespace :learning do
    match "/activity_homework" => "activity#homework", via: [:get, :post]
    get 'activity_get_batch' => 'activity#list_batch'
    get 'activity_question' => 'activity#question'
    get 'activity_project'  => 'activity#project'

    #Quan ly lop hoc
    get 'class'  => 'batch#list'

    #Quan ly khoa hoc
    get 'course' => 'course#index'

    
  end

  namespace :user do
    get 'all_user' => 'adm_users#all_user'
    get 'index' => 'adm_users#index'
    get 'user_info/:id' => 'adm_users#user_info'
    get 'edit_user_info/:id' => 'adm_users#edit_user_info'
    post 'update_user_info' => 'adm_users#update_user_info'
  end
end
