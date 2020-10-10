class Contest::ContestTopic < ApplicationRecord
  self.table_name = 'tk_contest_topics'

  has_one_attached :thumbnail

  belongs_to :contest, class_name: "Contest::Contest", foreign_key: 'contest_id'
end
