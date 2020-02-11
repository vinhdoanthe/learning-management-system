module User
  class OpStudent < ApplicationRecord
    self.table_name = 'op_student'

    has_many :op_parent_op_student_rels
    has_many :op_parents, through: :op_parent_op_student_rels

    has_many :op_student_courses, class_name: 'Learning::Batch::OpStudentCourse', foreign_key: 'student_id'
    has_many :op_batches, through: :op_student_courses, class_name: 'Learning::Batch::OpBatch'
  end
end