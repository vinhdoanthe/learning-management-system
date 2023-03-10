class Contest::ProjectCriterion < ApplicationRecord
  self.table_name = "tk_project_criterions"
  attribute :number, :integer, default: 0
  attribute :point_exchange, :integer, default: 0

  belongs_to :contest_project, class_name: "Contest::ContestProject", foreign_key: 'contest_project_id'

  belongs_to :contest_criterion, class_name: "Contest::ContestCriterion", foreign_key: 'contest_criterion_id'
end
