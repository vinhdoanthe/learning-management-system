namespace :user do
  namespace :open_educat do 
    get 'batches' => 'op_student#batches'
    get 'batch_detail/:batch_id' => 'op_student#batch_detail', as: 'batch_detail'
    get 'batch_progress' => 'op_student#batch_progress', as: 'batch_progress'
    get 'session_evaluation' => 'op_student#session_evaluation', as: 'session_evaluation'
  end
end
