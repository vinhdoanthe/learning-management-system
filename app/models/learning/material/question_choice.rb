module Learning
  module Material
    class QuestionChoice < ApplicationRecord
      belongs_to :question, inverse_of: :question_choices
      
      validates :choice_content, presence: true
    end
  end
end
