class Learning::Batch::GenBatchTableLine < ApplicationRecord
  self.table_name = 'gen_batch_table_line'
  
  belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
  belongs_to :op_faculty, class_name: 'User::OpenEducat::OpFaculty', foreign_key: 'faculty_id'
  belongs_to :op_subject, class_name: 'Learning::Course::OpCourse', foreign_key: 'subject_id'
  belongs_to :op_classroom, class_name: 'Common::OpClassroom', foreign_key: 'classroom_id'
end
