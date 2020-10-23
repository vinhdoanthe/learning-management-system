class Contest::ContestCriterion < ApplicationRecord
  self.table_name = "tk_contest_criterions"

  has_many :topic_criterions, class_name: "Contest::ContestTopicCriterion", foreign_key: 'contest_criterion_id'
  has_many :project_criterions, class_name: 'Contest::ProjectCriterion', foreign_key: 'contest_criterion_id'
end
