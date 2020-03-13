module Learning
  module LearningRecord
    class UserAnswer < ApplicationRecord
      belongs_to :user_question
      belongs_to :question_choice, required: false
      has_many :answer_marks, class_name: 'Learning::LearningRecord::AnswerMark', foreign_key: 'user_answer_id'
    end
  end
end