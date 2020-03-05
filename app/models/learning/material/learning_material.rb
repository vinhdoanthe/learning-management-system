module Learning
  module Material
    class LearningMaterial < ApplicationRecord
      extend Enumerize

      belongs_to :op_lession, class_name: 'Learning::Course::OpLession'

      enumerize :material_type, in: [Learning::Constant::Material::MATERIAL_TYPE_FILE, Learning::Constant::Material::MATERIAL_TYPE_VIDEO]
      enumerize :learning_type, in: [Learning::Constant::Material::MATERIAL_TYPE_TEACH, Learning::Constant::Material::MATERIAL_TYPE_REVIEW]

      has_one_attached :material_file
    end
  end
end

