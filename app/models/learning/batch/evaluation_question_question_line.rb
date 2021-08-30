class Learning::Batch::EvaluationQuestionQuestionLine < ApplicationRecord
  self.table_name = 'evaluation_question_line_rel'

  belongs_to :evaluation_question, class_name: 'Learning::Batch::EvaluationQuestion', foreign_key: :question_id
  belongs_to :evaluation_question_line, class_name: 'Learning::Batch::EvaluationQuestionLine', foreign_key: :question_line_id
end
