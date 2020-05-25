class Learning::Course::OpCourseOpSubjectRel < ApplicationRecord
  self.table_name = 'op_course_op_subject_rel'
  self.primary_keys = :op_course_id, :op_subject_id

  belongs_to :op_course, class_name: "Learning::Course::OpCourse", foreign_key: 'op_course_id'
  belongs_to :op_subject, class_name: "Learning::Course::OpSubject", foreign_key: 'op_subject_id'
end
