module Learning
  module Batch
    class OpStudentCourse < ApplicationRecord
      self.table_name = 'op_student_course'

      belongs_to :op_batch, :foreign_key => 'batch_id'
      belongs_to :op_student, :foreign_key => 'student_id'
    end
  end
end