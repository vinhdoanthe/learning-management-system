module Learning
  module Course
    class OpCourse < ApplicationRecord
      self.table_name = 'op_course'
      
      belongs_to :course_categ, foreign_key: 'categ_id'

      has_many :op_batches, class_name: 'Learning::Batch::OpBatch', foreign_key: 'course_id'
      has_many :op_subjects, foreign_key: 'course_id'
      has_many :op_sessions, class_name: 'Learning::Batch::OpSession', foreign_key: 'course_id'

      has_many :course_description, foreign_key: :op_course_id, inverse_of: :op_course
      accepts_nested_attributes_for :course_description, allow_destroy: true

      has_one_attached :thumbnail
    end
  end
end
