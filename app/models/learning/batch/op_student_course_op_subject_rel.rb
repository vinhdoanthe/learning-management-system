module Learning
  module Batch
    class OpStudentCourseOpSubjectRel < ApplicationRecord
      self.table_name = 'op_student_course_op_subject_rel'

      belongs_to :op_student_course, foreign_key: 'op_student_course_id'
      belongs_to :op_subject, class_name: 'Learning::Course::OpSubject', :foreign_key => 'op_subject_id'
    end
  end
end