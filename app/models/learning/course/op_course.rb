module Learning
  module Course
    class OpCourse < ApplicationRecord
      self.table_name = 'op_course'

      has_many :op_batches, class_name: 'Learning::Batch::OpBatch', foreign_key: 'course_id'
    end
  end
end