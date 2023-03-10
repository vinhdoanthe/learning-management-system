namespace :user do
  namespace :open_educat do
    get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    get 'teacher_class' => 'op_teachers#teacher_class'
    post 'teacher_class_content' => 'op_teachers#teacher_class_content'
    post 'teacher_checkin' => 'op_teachers#teacher_checkin'
    post 'teacher_attendance' => 'op_teachers#teacher_attendance'
    post 'teaching_schedule_content' => 'op_teachers#teaching_schedule_content'
    get 'teacher_schedule' => 'op_teachers#teaching_schedule'
    get 'teacher_info' => 'op_teachers#teacher_info'
    namespace :op_teachers do
      get 'checkin_report', action: 'checkin_report', as: 'checkin_report'
      get 'attendance_report', action: 'attendance_report', as: 'attendance_report'
      get 'student_projects', action: 'student_projects', as: 'student_projects'
      get 'assign_homework_details', action: 'assign_homework_details', as: 'assign_homework_details'
      post 'assign_homework', action: 'assign_homework', as: 'assign_homework'
      post 'teacher_evaluate', action: 'teacher_evaluate', as: 'teacher_evaluate'
    end
  end
end
