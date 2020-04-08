class Learning::Batch::OpStudentSubject < ApplicationRecord
    self.table_name = 'op_student_subject'

    belongs_to :op_student_course, :foreign_key => 'student_course_id'
    belongs_to :op_subject, :class_name => 'Learning::Course::OpSubject', :foreign_key => 'subject_id'
end
