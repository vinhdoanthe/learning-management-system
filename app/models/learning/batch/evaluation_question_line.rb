class Learning::Batch::EvaluationQuestionLine < ApplicationRecord
  self.table_name = 'op_session_evaluation_question_line'

  belongs_to :evaluation_group, class_name: 'Learning::Batch::EvaluationQuestionGroup', foreign_key: 'group_id'

  self.inheritance_column = 'question_type'
end
