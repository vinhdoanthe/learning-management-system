namespace :learning do
  get 'active_session' => 'batch/sessions#active_session'
  get 'subject_lesson' => 'course/op_subjects#subject_lesson'
  get 'vimeo' => 'material/learning_materials#vimeo'
  get 'list_slides_of_subject/:subject_id' => 'learning_materials#list_slides_of_subject', as: 'list_slides_of_subject'
  get 'show_google_slide/:slide_id' => 'learning_materials#show_google_slide', as: 'show_google_slide'
  get 'op_session/session_photo' => 'batch/sessions#session_photo'
  get 'op_session/session_reward' => 'batch/sessions#session_reward'
  get 'op_session/session_photo_review' => 'batch/sessions#session_photo_review'

  post 'add_vimeo' => 'learning_materials#add_vimeo'
  put 'update_vimeo' => 'learning_materials#update_vimeo'

  post 'reward_student' => 'batch/session_student_rewards#reward_student'
  post 'student_feeback' => 'batch/session_student_feedbacks#student_feedback'
end