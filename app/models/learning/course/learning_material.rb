module Learning
  module Course
    class LearningMaterial < ApplicationRecord
      extend Enumerize

      belongs_to :op_lession, foreign_key: 'op_lession_id'

      enumerize :material_type, in: [Learning::Constant::Course::MATERIAL_TYPE_FILE, Learning::Constant::Course::MATERIAL_TYPE_VIDEO]
      enumerize :learning_type, in: [Learning::Constant::Course::LEARNING_TYPE_TEACH, Learning::Constant::Course::LEARNING_TYPE_REVIEW]

      has_one_attached :material_file
    end
  end
end

