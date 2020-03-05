module Learning
  module LearningRecord
    class AnswerMark < ApplicationRecord
      belongs_to :user_answer
      belongs_to :user, class_name: 'User::User', foreign_key: 'teacher_id'
    end
  end
end