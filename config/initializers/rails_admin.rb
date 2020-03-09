RailsAdmin.config do |config|
  config.main_app_name = ['LMS SYSTEM']
  config.parent_controller = "::ApplicationController"

  config.authenticate_with do
    unless current_user&.is_admin?
      redirect_to(
          main_app.root_path,
          alert: "You are not permitted to view this page"
      )
    end
  end

  config.current_user_method(&:current_user)


  ActiveRecord::Base.descendants.each do |imodel|
    config.model "#{imodel.name}" do
      list do
        exclude_fields :created_at, :updated_at
      end
    end
  end
  config.included_models = %w(Learning::Course::OpCourse Learning::Course::OpSubject Learning::Course::OpLession Learning::Material::LearningMaterial
                              Learning::Batch::OpBatch Learning::Batch::OpSession Learning::Material::Question Learning::Material::QuestionChoice
                              User::User Learning::LearningRecord::UserQuestion)


  config.model 'Learning::Course::OpCourse' do
    show do
      field :name
      field :code
      field :section
      field :op_subjects
      field :thumbnail
    end
    edit do
      field :name
      field :code
      field :section
      field :op_subjects
      field :thumbnail
    end
  end

  config.model 'Learning::Course::OpSubject' do
    show do
      field :op_course
      field :name
      field :code
      field :level
      field :op_lessions
    end

    edit do
      field :op_course
      field :name
      field :code
      field :level
      field :op_lessions
    end
  end

  config.model 'Learning::Course::OpLession' do
    show do
      field :op_subject
      field :lession_number
      field :code
      field :name
      field :note
      field :learning_devices
      field :learning_materials
      field :questions
      field :thumbnail
    end
    edit do
      field :op_subject
      field :lession_number
      field :code
      field :name
      field :note
      field :learning_devices
      field :learning_materials
      field :questions
      field :thumbnail
    end
  end

  config.model 'User::User' do
    show do
      field :username
      field :email
      field :account_role
      field :avatar
      field :op_faculty
      field :op_parent
      field :op_student
    end

    edit do
      field :username
      field :email
      field :password
      field :account_role
      field :avatar
      field :op_faculty
      field :op_parent
      field :op_student
    end
  end

  config.model 'Learning::Material::Question' do
    show do
      field :op_lession
      field :question do
        pretty_value do
          value.html_safe
        end
      end
      field :question_type
      field :question_choices
      field :is_active
    end

    edit do
      field :op_lession
      field :question, :ck_editor do
        config_js ActionController::Base.helpers.asset_path('ckeditor/config.js')
      end
      field :question_type
      field :question_choices
      field :is_active
    end
  end

  config.model 'Learning::Material::QuestionChoice' do
    show do
      field :question
      field :is_right_choice
      field :choice_content
    end

    edit do
      field :question
      field :is_right_choice
      field :choice_content
    end
  end
  config.model 'Learning::LearningRecord::UserQuestion' do
    show do
      field :user
      field :question
      field :op_batch
    end
    
    edit do
      field :user
      field :question
      field :op_batch
    end
  end
  config.actions do

    dashboard
    index
    new
    show
    edit
    delete do
      only %w(Learning::Material::LearningMaterial Learning::Material::Question Learning::Material::QuestionChoice)
    end
  end
end
