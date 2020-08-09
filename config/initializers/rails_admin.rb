RailsAdmin.config do |config|

  config.main_app_name = ['LMS SYSTEM']
  config.parent_controller = "::ApplicationController"
  config.default_items_per_page = 100

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
  config.included_models = %w(Common::RewardType Common::FeelingType
                              Learning::Course::OpCourse Learning::Course::CourseDescription Learning::Course::OpLession 
                              Learning::Batch::OpBatch Learning::Batch::OpSession 
                              Learning::Material::Question Learning::Material::QuestionChoice Learning::Material::LearningMaterial
                              User::Account::User User::OpenEducat::OpStudent User::OpenEducat::OpFaculty User::Account::Avatar
                              Learning::Homework::UserQuestion
                              Notification::BroadcastNoti
                              User::Reward::TekyCoinStarActivitySetting
                              Utility::PublicCourse
                              SocialCommunity::ScStudentProject
                              )


  config.model 'Learning::Course::OpCourse' do
    list do
      field :id
      field :name
      field :link do
        formatted_value do
          path = bindings[:object].link
          bindings[:view].link_to('Preview', path)
        end
      end
    end

    show do
      field :link do
        formatted_value do
          path = bindings[:object].link
          bindings[:view].link_to('Preview', path)
        end
      end
      field :name
      field :short_description
      field :suitable_age
      field :duration
      field :course_description
      field :thumbnail
    end

    edit do
      field :short_description
      field :suitable_age
      field :duration
      field :course_description
      field :thumbnail
    end
  end

  config.model 'Learning::Course::CourseDescription' do
    list do

    end

    show do
      field :description do
        pretty_value do
          value.html_safe
        end
      end
    end

    edit do
      field :description, :ck_editor do
        config_js ActionController::Base.helpers.asset_path('ckeditor/config.js')
      end
    end
  end

  config.model 'Learning::Course::OpLession' do
    list do
      field :name do
        formatted_value do
          path = bindings[:view].show_path(model_name: 'Learning::Course::OpLession', id: bindings[:object].id)
          bindings[:view].link_to(bindings[:object].name, path)
        end
      end
      field :op_subject do
        searchable [:name]
        queryable true
        filterable true
      end
      field :op_course_name
      field :course_category
      field :link do
        formatted_value do
          path = bindings[:object].link
          bindings[:view].link_to('Preview', path)
        end
      end
    end

    show do
      field :link do
        formatted_value do
          path = bindings[:object].link
          bindings[:view].link_to('Preview', path)
        end
      end
      field :course_category
      field :op_course_name
      field :op_subject
      field :name
      field :note
      field :learning_devices
      field :learning_materials
      field :questions
      field :thumbnail
    end

    edit do
      field :learning_devices
      field :learning_materials
      field :questions
      field :thumbnail
    end
  end

  config.model 'User::Account::User' do
    list do
      field :id
      field :username
      field :email
      field :account_role
      field :student_name
      field :parent_name
      field :faculty_name
      field :center_name
    end

    show do
      field :username
      field :email
      field :account_role
      field :student_name
      field :parent_name
      field :faculty_name
      field :center_name
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

    export do
      field :username
      field :email
      field :account_role
      field :student_name
      field :parent_name
      field :faculty_name
      field :center_name
    end
  end

  config.model 'User::OpenEducat::OpStudent' do
    list do
      field :full_name
      field :code
      field :vattr_gender
      field :birth_date
      field :nationality
      field :vattr_center_name
    end

    show do
      field :full_name
      field :code
      field :vattr_gender
      field :birth_date
      field :nationality
      field :vattr_center_name
      field :users
    end

    export do
      field :full_name
      field :code
      field :vattr_gender
      field :birth_date
      field :nationality
      field :vattr_center_name
      field :vattr_parent_full_name
      field :vattr_parent_relation_type
      field :vattr_parent_email
      field :vattr_parent_phone
      field :vattr_parent_address
      field :vattr_parent_district
      field :vattr_parent_nation
      field :create_date
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
  config.model 'Learning::Homework::UserQuestion' do
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

  config.model 'Learning::Batch::OpSession' do
    list do
      field :start_datetime
      field :end_datetime
      field :batch_code
      field :lesson
      field :photos_link
    end

    show do 
      field :start_datetime
      field :end_datetime
      field :batch_code
      field :lesson
      field :photos_link
    end

    export do 
      field :start_datetime
      field :end_datetime
      field :batch_code
      field :lesson
      field :photos_link
    end
  end

  config.model 'User::Reward::TekyCoinStarActivitySetting' do
    list do
      field :setting_key
      field :description
      field :is_add_coin
      field :is_add_star
      field :coin
      field :star
      field :created_by
    end

    show do      
      field :setting_key
      field :description
      field :is_add_coin
      field :is_add_star
      field :coin
      field :star
      field :created_by
    end

    edit do
      field :is_add_coin
      field :is_add_star
      field :coin
      field :star
    end
  end

  config.model 'SocialCommunity::ScStudentProject' do 
    list do
      include_fields :op_course, :op_batch, :op_subject, :op_student, :name, :state, :permission, :introduction_video, :presentation, :project_show_video, :created_at, :updated_at
      # field :op_course
      # field :op_batch
      # field :op_subject
      # field :op_student
      # field :name
      # field :state
      # field :permission
      # field :description
      # field :introduction_video
      # field :presentation
      # field :project_show_video
      # field :created_at
      # field :updated_at
    end

    show do
      field :op_course
      field :op_batch
      field :op_subject
      field :op_student
      field :name
      field :state
      field :permission
      field :description do
        pretty_value do
          value.html_safe
        end
      end
      field :introduction_video
      field :presentation
      field :project_show_video
      field :created_at
      field :updated_at
    end

    edit do
      field :op_course
      field :op_batch
      field :op_subject
      field :op_student
      field :name
      field :state
      field :permission
      field :introduction_video
      field :presentation
      field :project_show_video
    end
  end

  config.actions do

    dashboard
    index
    new do
      only %w(Common::RewardType Common::FeelingType
              Learning::Course::CourseDescription 
              Learning::Material::LearningMaterial Learning::Material::Question Learning::Material::QuestionChoice
              Notification::BroadcastNoti
              User::Account::Avatar
              Utility::PublicCourse)
    end
    show
    show_in_app do
      only %w(Learning::Course::OpLession)
    end
    edit do
      only %w(Common::RewardType Common::FeelingType
              Learning::Material::LearningMaterial Learning::Material::Question Learning::Material::QuestionChoice, 
              Learning::Course::OpLession Learning::Course::OpCourse Learning::Course::CourseDescription 
              Notification::BroadcastNoti
              User::Reward::TekyCoinStarActivitySetting
              Utility::PublicCourse
              SocialCommunity::ScStudentProject)
    end
    delete do
      only %w(Common::RewardType Common::FeelingType
              Learning::Material::LearningMaterial Learning::Material::Question Learning::Material::QuestionChoice
              Utility::PublicCourse)
    end

    export do
      only %w(User::Account::User User::OpenEducat::OpStudent
              Learning::Batch::OpSession)
    end
  end
end
