namespace :user do
  namespace :open_educat do
    get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    post 'teacher_checkin' => 'op_teachers#teacher_checkin'
    post 'teacher_attendance' => 'op_teachers#teacher_attendance'
  end
end
