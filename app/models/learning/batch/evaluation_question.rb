class Learning::Batch::EvaluationQuestion < ApplicationRecord
  self.table_name = 'op_session_evaluation_question'

  has_many :question_line_rels, class_name: 'Learning::Batch::EvaluationQuestionQuestionLine', foreign_key: :question_id
  has_many :evaluation_answers, through: :question_line_rels
end
