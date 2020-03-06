module Learning
  module Material
    class Question < ApplicationRecord
      extend Enumerize
      include Constant

      enumerize :question_type, in: [Constant::Material::QUESTION_TEXT_RESPONSE,
                                     Constant::Material::QUESTION_SINGLE_CHOICE,
                                     Constant::Material::QUESTION_MULTIPLE_CHOICES]
      belongs_to :op_lession, class_name: 'Learning::Course::OpLession', inverse_of: :questions
      has_many :question_choices, inverse_of: :question
      accepts_nested_attributes_for :question_choices, allow_destroy: true
    end
  end
end