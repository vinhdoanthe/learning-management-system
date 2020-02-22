module Learning
  module Course
    class OpLession < ApplicationRecord
      self.table_name = 'op_lession'

      belongs_to :op_subject, foreign_key: :subject_id
      has_many :learning_materials, :foreign_key => 'op_lession_id'

      has_one_attached :thumbnail
    end
  end
end