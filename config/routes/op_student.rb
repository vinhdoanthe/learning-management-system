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
      get 'information', action: 'information', as: 'information'
      get 'timetable', action: 'timetable', as: 'timetable'
      post 'timetable', action: 'timetable'
    end
  end
end
