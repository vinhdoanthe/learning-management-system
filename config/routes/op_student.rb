namespace :user do
  namespace :open_educat do
   namespace :op_student do
    get 'batches', action: 'batches'
    get 'batch_detail/:batch_id', action: 'batch_detail', as: 'batch_detail'
    get 'batch_progress', action: 'batch_progress', as: 'batch_progress'
    get 'session_evaluation', action: 'session_evaluation', as: 'session_evaluation'
   end 
  end
end
