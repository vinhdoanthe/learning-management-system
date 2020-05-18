module Learning
  module Batch
    class OpStudentCourse < ApplicationRecord
      self.table_name = 'op_student_course'

      belongs_to :op_batch, :foreign_key => 'batch_id'
      belongs_to :op_student, :class_name => 'User::OpenEducat::OpStudent', :foreign_key => 'student_id'
      belongs_to :op_course, :class_name => 'Learning::Course::OpCourse', :foreign_key => 'course_id'
=begin
      has_many :op_student_course_op_subject_rels, foreign_key: 'op_student_course_id'
      has_many :op_subjects, :class_name => 'Learning::Course::OpSubject', through: :op_student_course_op_subject_rels
=end
      has_many :student_course_admissions, class_name: 'Learning::Batch::StudentCourseAdmission', foreign_key: :student_course_id
      has_many :op_admissions, class_name: 'Learning::Batch::OpAdmission', through: :student_course_admissions
      has_many :op_subjects, class_name: 'Learning::Course::OpSubject', through: :op_admissions
      # has_many :op_student_subjects, :foreign_key => 'student_course_id'
      # has_many :op_subjects, :class_name => 'Learning::Course::OpSubject', through: :op_student_subjects
      has_many :op_session_students, :foreign_key => 'student_course_id'
    end
  end
end
