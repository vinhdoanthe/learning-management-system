module Learning
  module Batch
    class OpStudentCourse < ApplicationRecord
      self.table_name = 'op_student_course'

      belongs_to :op_batch, :foreign_key => 'batch_id'
      belongs_to :op_student, :class_name => 'User::OpStudent', :foreign_key => 'student_id'


      has_many :op_student_course_op_subject_rels, :class_name => 'Learning::Batch::OpStudentCourseOpSubjectRel', foreign_key: 'op_student_course_id'
      has_many :op_subjects, :class_name => 'Learning::Course::OpSubject', through: :op_student_course_op_subject_rels
    end
  end
end