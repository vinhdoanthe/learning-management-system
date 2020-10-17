class Contest::ContestTopicCriterion < ApplicationRecord
  self.table_name = "tk_topic_criterions"

  belongs_to :contest_topic, class_name: "Contest::ContestTopic", foreign_key: 'contest_topic_id'
  belongs_to :contest_criterion, class_name: "Contest::ContestCriterion", foreign_key: 'contest_criterion_id'

end
