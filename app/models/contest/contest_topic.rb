class Contest::ContestTopic < ApplicationRecord
  self.table_name = 'tk_contest_topics'

  has_one_attached :thumbnail

  belongs_to :contest, class_name: "Contest::Contest", foreign_key: 'contest_id'
  has_many :contest_projects, class_name: "Contest::ContestProject", foreign_key: "contest_topic_id"
end
