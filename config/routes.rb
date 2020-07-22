class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  scope :user do
    scope :account do
      notify_to 'users', controller: 'notification/user/user_notifications'
    end
  end

  get '/user/account/users/:user_id/notifications/:id/open', :to => 'notification/user/user_notifications#open', target_type: 'users'

  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'user/home#dashboard'
  get 'coming_soon_page' => 'user/home#coming_soon', as: 'coming_soon_page' 
  post 'uploader/image' => 'uploader#image', as: 'image_uploader'

  draw :op_student
  draw :learning
  draw :op_teacher
  draw :social_community
  draw :user
  draw :redeem
  draw :report
  draw :adm

  namespace :learning do
    get 'view_learning_material/:material_id' => 'learning_materials#view_learning_material'
    get 'pdf_materials' => 'learning_materials#pdf_materials'
    get 'show_pdf/:session_id' => 'learning_materials#show_pdf', as: 'show_single_pdf'
    get 'show_google_doc_materials/:session_id' => 'learning_materials#show_google_doc_materials', as: 'show_google_doc_materials'
    get 'show_video/:session_id' => 'learning_materials#show_video', as: 'show_single_video'
    get 'video/next_video' => 'learning_materials#next_video'
    get 'view_question' => 'learning_records#view_question'
    get 'question_content' => 'learning_records#question_content'
    post 'answer_question' => 'learning_records#answer_question'
    get 'marking_question' => 'learning_records#marking_question'
    get 'batch_user_answer_list' => 'learning_records#batch_user_answer_list'
    get 'get_user_answer' => 'learning_records#get_user_answer'
    post 'mark_answer' => 'learning_records#mark_answer'
    get 'ziggeos' => 'learning_materials#ziggeo'
    get 'course/op_lesson/:lession_id' => 'course/op_lession#preview_lesson_material', as: 'preview_lesson'
    get 'course/op_courses' => 'course/op_courses#index', as: 'list_courses'
    get 'courses_by_category' => 'course/op_courses#index_by_category', as: 'courses_by_category'
    get 'course/op_course/show/:course_id' => 'course/op_courses#show', as: 'show_course'
    get 'course/op_lessons' => 'course/op_lession#index', as: 'list_lessons'
    get 'course/op_lesson/edit/:lession_id' => 'course/op_lession#edit', as: 'edit_lesson'
    get 'lessons_by_category' => 'course/op_lession#index_by_category', as: 'lessons_by_category'
    get 'lessons_by_course' => 'course/op_lession#index_by_course', as: 'lessons_by_course'
    get 'lessons_by_subject' => 'course/op_lession#index_by_subject', as: 'lessons_by_subject'
    get 'get_video_list' => 'learning_materials#get_video_list'
    get 'assign_session' => 'course/op_subjects#assign_session'
  end

  namespace :notification do
    namespace :broadcast do
      resources :broadcast_notices, only: [:index, :show]
      get 'read_notice' => 'broadcast_notices#read_notice'
    end
  end

#  resources :password_resets, only: [:new, :create, :edit, :update]
  post 'add_photo_attachment' => 'learning/batch/sessions#add_photo_attachment'

  delete 'sign_out', :to => 'user/sessions#destroy', as: 'logout'
  get 'courses' => 'learning/course/op_courses#public_courses', as: 'courses'
  get 'course_detail' => 'learning/course/op_courses#public_course_detail', as: 'course_detail'
end
