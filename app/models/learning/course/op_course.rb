module Learning
  module Course
    class OpCourse < ApplicationRecord
      self.table_name = 'op_course'

      has_many :op_batches, class_name: 'Learning::Batch::OpBatch', foreign_key: 'course_id'
      has_many :op_subjects, foreign_key: 'course_id'

      has_one_attached :thumbnail
    end
  end
end