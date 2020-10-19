class Contest::ProjectCriterion < ApplicationRecord
  self.table_name = "tk_project_criterions"

  belongs_to :contest_project, class_name: "Contest::ContestProject", foreign_key: 'contest_project_id'

  has_one :contest_criterion, class_name: "Contest::ContestCriterion", foreign_key: 'criterion_id'
end
