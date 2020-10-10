class Contest::ContestTopicPrize < ApplicationRecord
  self.table_name = "tk_contest_topic_prizes"

  has_one :contest_topic, class_name: "Contest::ContestTopic"
  has_one :contest_prize, class_name: "Contest::ContestPrize"

end

