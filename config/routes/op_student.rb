namespace :user do
  namespace :open_educat do 
    get 'batches' => 'op_student#batches'
    get 'batch_detail/:batch_id' => 'op_student#batch_detail', as: 'batch_detail'
  end
end
