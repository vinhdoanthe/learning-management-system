module Learning
  module Material
    class Question < ApplicationRecord
      extend Enumerize
      include Constant

      enumerize :question_type, in: [Constant::Material::QUESTION_TEXT_RESPONSE,
                                     Constant::Material::QUESTION_SINGLE_CHOICE,
                                     Constant::Material::QUESTION_MULTIPLE_CHOICES]
      belongs_to :op_lession, class_name: 'Learning::Course::OpLession'
      has_many :question_choices
    end
  end
end