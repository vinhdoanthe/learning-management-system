namespace :user do
  namespace :open_educat do
    get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    post 'teacher_checkin' => 'op_teachers#teacher_checkin'
    post 'teacher_attendance' => 'op_teachers#teacher_attendance'
    post 'teaching_schedule_content' => 'op_teachers#teaching_schedule_content'
    get 'teacher_schedule' => 'op_teachers#teaching_schedule'
  end
end
