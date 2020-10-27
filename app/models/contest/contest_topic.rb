class Contest::ContestTopic < ApplicationRecord
  after_create :ser_number_week
  self.table_name = 'tk_contest_topics'

  has_one_attached :thumbnail

  belongs_to :contest, class_name: "Contest::Contest", foreign_key: 'contest_id'

  has_many :contest_projects, class_name: "Contest::ContestProject", foreign_key: "contest_topic_id"
  has_many :topic_criterions, class_name: "Contest::ContestTopicCriterion", foreign_key: "contest_topic_id"
  has_many :topic_prizes, class_name: "Contest::ContestTopicPrize", foreign_key: 'contest_topic_id'
  has_many :contest_prizes, class_name: "Contest::ContestPrize", through: :topic_prizes
  has_many :contest_criterions, class_name: 'Contest::ContestCriterion', through: :topic_criterions

  def set_number_week
    self.number_week = (self.start_time.strftime('%d').to_id / 7) + 1
    self.number_week = 4 if self.number_week == 5
    save
  end
end
