module Learning
  module LearningRecord
    class UserAnswer < ApplicationRecord
      belongs_to :user_question
      belongs_to :question_choice, required: false
    end
  end
end