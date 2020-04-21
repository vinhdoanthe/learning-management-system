namespace :learning do
    get 'active_session' => 'batch/sessions#active_session'
    get 'subject_lesson' => 'course/op_subjects#subject_lesson'
    get 'vimeo' => 'material/learning_materials#vimeo'
end
