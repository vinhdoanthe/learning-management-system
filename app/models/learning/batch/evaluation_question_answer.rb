class Learning::Batch::EvaluationQuestionAnswer < ApplicationRecord
  self.table_name = 'evaluation_question_answer_rel'

  belongs_to :question, class_name: 'Learning::Batch::EvaluationQuestion', foreign_key: :question_id
  belongs_to :question_line, class_name: 'Learning::Batch::EvaluationQuestionLine', foreign_key: :question_line_id
end
