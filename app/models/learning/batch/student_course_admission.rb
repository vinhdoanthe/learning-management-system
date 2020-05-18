class Learning::Batch::StudentCourseAdmission < ApplicationRecord
  self.table_name = 'student_course_admission'

  belongs_to :op_student_course, foreign_key: 'student_course_id', required: false
  belongs_to :op_admission, foreign_key: 'admission_id', required: false
end
