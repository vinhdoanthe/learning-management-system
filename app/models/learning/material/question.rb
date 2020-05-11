module Learning
  module Material
    class Question < ApplicationRecord
      extend Enumerize
      include Constant

      enumerize :question_type, in: [Constant::Material::QUESTION_TEXT_RESPONSE,
                                     Constant::Material::QUESTION_SINGLE_CHOICE,
                                     Constant::Material::QUESTION_MULTIPLE_CHOICES]
      belongs_to :op_lession, class_name: 'Learning::Course::OpLession', inverse_of: :questions
      has_many :question_choices, :dependent => :destroy, inverse_of: :question
      has_many :user_questions, class_name: 'Learning::Homework::UserQuestion', :dependent => :nullify
      accepts_nested_attributes_for :question_choices, allow_destroy: true

      validates :question_type, presence: true
      validates :question, presence: true
      validate :has_question_choice

      def has_question_choice
        if question_type != 'text' && question_choices.length == 0
          errors.add(:question_choice, 'Thiếu lựa chọn trả lời')
        end
      end
    end
  end
end
