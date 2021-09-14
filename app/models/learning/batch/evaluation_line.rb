class Learning::Batch::EvaluationLine < ApplicationRecord
  self.table_name = 'op_session_evaluation_line'

  belongs_to :evaluation, class_name: 'Learning::Batch::Evaluation', foreign_key: :evaluation_id
  belongs_to :question_line, class_name: 'Learning::Batch::EvaluationQuestionLine', foreign_key: :question_line_id

  self.inheritance_column = 'evaluation_line_type'
end
