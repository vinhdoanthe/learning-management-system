module Learning
  module Course
    class OpSubject < ApplicationRecord
      self.table_name = 'op_subject'
      self.inheritance_column = 'object_type'

      belongs_to :op_course, foreign_key: :course_id

      has_many :op_student_course_op_subject_rels, :class_name => 'Learning::Batch::OpStudentCourseOpSubjectRel', foreign_key: 'op_subject_id'
      has_many :op_student_courses, :class_name => 'Learning::Batch::OpStudentCourse', through: :op_student_course_op_subject_rels
      has_many :op_sessions, class_name: 'Learning::Batch::OpSession', foreign_key: 'subject_id'
      has_many :op_lessions, foreign_key: 'subject_id'
      has_one_attached :thumbnail
    end
  end
end
