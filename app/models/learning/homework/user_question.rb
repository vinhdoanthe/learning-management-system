module Learning
  module Homework
    class UserQuestion < ApplicationRecord
      belongs_to :question, class_name: 'Learning::Material::Question', optional: true
      belongs_to :user, class_name: 'User::Account::User', :foreign_key => 'student_id'
      belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch'

      has_many :user_answers
    end
  end
end
