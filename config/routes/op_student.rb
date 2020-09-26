namespace :user do
  namespace :open_educat do
    get 'session_student' => 'op_students#session_student'
    get 'student_evaluate' => 'op_students#student_evaluate'
    namespace :op_students do
      get 'batches', action: 'batches'
      get 'batch_detail/:batch_id', action: 'batch_detail', as: 'batch_detail'
      get 'batch_progress', action: 'batch_progress', as: 'batch_progress'
      get 'session_evaluation', action: 'session_evaluation', as: 'session_evaluation'
      get 'student_homework', action: 'student_homework', as: 'student_homework'
      get 'student_homework_content', action: 'student_homework_content', as: 'student_homework_content'
      get 'information', action: 'information', as: 'information'
      get 'timetable', action: 'timetable', as: 'timetable'
      post 'timetable_content', action: 'timetable_content', as: 'timetable_content'
      post 'timetable', action: 'timetable'
      get 'public_profile/:op_student_id', action: 'public_profile', as: 'public_profile'
      get 'filter_subject_homework', action: 'filter_subject_homework', as: 'filter_subject_homework'
      get 'filter_batch_homework', action: 'filter_batch_homework', as: 'filter_batch_homework'
      get 'filter_course_homework', action: 'filter_course_homework', as: 'filter_course_homework'
      get 'attendance_report', action: 'attendance_report', as: 'attendance_report'
      get 'student_projects', action: 'student_projects', as: 'student_projects'
      get 'student_project_detail', action: 'student_project_detail', as: 'student_project_detail'
      get 'video_review_list', action: 'video_review_list', as: 'video_review_list'
    end
  end
end
