namespace :report do
  get 'diligent' => 'report#diligent'
  post 'diligent' => 'report#diligent'
  get 'study' => 'report#study'
  get 'general' => 'report#general'
end
