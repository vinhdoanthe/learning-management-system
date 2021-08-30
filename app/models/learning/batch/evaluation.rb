class Learning::Batch::Evaluation < ApplicationRecord
  self.table_name = 'op_session_evaluation'

  belongs_to :session, class_name: 'Learning::Batch::Session', foreign_key: :session_id
  belongs_to :teacher, class_name: 'User::OpenEducat::OpFaculty', foreign_key: :faculty_id
  belongs_to :student, class_name: 'User::OpenEducat::OpStudent', foreign_key: :student_id
  belongs_to :question, class_name: 'Learning::Batch::EvaluationQuestion', foreign_key: :question_id

  has_many :evaluation_lines, class_name: 'Learning::Batch::EvaluationLine', foreign_key: :evaluation_id
end
