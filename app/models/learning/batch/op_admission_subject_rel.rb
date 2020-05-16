class Learning::Batch::OpAdmissionSubjectRel < ApplicationRecord
 self.table_name = 'op_admission_subject_rel'
 self.primary_keys = :admission_id, :subject_id

 belongs_to :op_admission, foreign_key: :admission_id
 belongs_to :op_subjects, class_name: 'Learning::Course::OpSubject', foreign_key: :subject_id
end
