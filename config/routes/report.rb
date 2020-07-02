namespace :report do
  get 'diligent'     => 'report#diligent'
  post 'diligent'    => 'report#diligent'
  
  get 'teaching'     => 'report#teaching'
  post 'teaching'    => 'report#teaching'
  
  get 'teaching_checkin'      => 'report#teaching_checkin'
  post 'teaching_checkin'     => 'report#teaching_checkin'
  
  
  
  get 'study'        => 'report#study'
  get 'general'      => 'report#general'
end