class Contest::Contest < ApplicationRecord
  self.table_name = 'tk_contests'
  validates_uniqueness_of :alias_name

  has_many :contest_topics, class_name: "Contest::ContestTopic", foreign_key: 'contest_id'
  has_many :contest_prizes, class_name: "Contest::ContestPrize", foreign_key: 'contest_id'
  has_many :contest_projects, class_name: "Contest::ContestProject", foreign_key: 'contest_id'
end
