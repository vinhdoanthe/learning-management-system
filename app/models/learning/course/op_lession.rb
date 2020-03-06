module Learning
  module Course
    class OpLession < ApplicationRecord
      self.table_name = 'op_lession'

      belongs_to :op_subject, foreign_key: :subject_id

      has_many :learning_materials, class_name: 'Learning::Material::LearningMaterial', inverse_of: :op_lession
      has_many :questions, class_name: 'Learning::Material::Question', inverse_of: :op_lession

      has_one_attached :thumbnail
    end
  end
end