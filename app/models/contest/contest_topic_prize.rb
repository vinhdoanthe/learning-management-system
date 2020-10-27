class Contest::ContestTopicPrize < ApplicationRecord
  self.table_name = "tk_topic_prizes"

  belongs_to :contest_topic, class_name: "Contest::ContestTopic"
  belongs_to :contest_prize, class_name: "Contest::ContestPrize"

end

