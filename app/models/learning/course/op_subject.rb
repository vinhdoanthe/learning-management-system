module Learning
  module Course
    class OpSubject < ApplicationRecord
      self.table_name = 'op_subject'
      self.inheritance_column = 'object_type'

      belongs_to :op_course, foreign_key: :course_id
      has_many :op_student_course_op_subject_rels, :class_name => 'Learning::Batch::OpStudentCourseOpSubjectRel', foreign_key: 'op_subject_id'
    end
  end
end