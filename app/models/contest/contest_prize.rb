class Contest::ContestPrize < ApplicationRecord
  self.table_name = "tk_contest_prizes"

  has_many :contest_projects, class_name: "Contest::ContestProject", foreign_key: 'contest_prize_id'
  serialize :month_active, Array
end
