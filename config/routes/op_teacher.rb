namespace :user do
  namespace :open_educat do
    get 'teacher_class_detail' => 'op_teachers#teacher_class_detail'
    post 'teacher_checkin' => 'op_teachers#teacher_checkin'
    post 'teacher_attendance' => 'op_teachers#teacher_attendance'
    post 'teaching_schedule_content' => 'op_teachers#teaching_schedule_content'
    get 'teacher_schedule' => 'op_teachers#teaching_schedule'
    namespace :op_teachers do
    get 'checkin_report', action: 'checkin_report', as: 'checkin_report'
    get 'attendance_report', action: 'attendance_report', as: 'attendance_report'
    get 'student_projects', action: 'student_projects', as: 'student_projects'
    end
  end
end
