class Contest::ContestTopic < ApplicationRecord
  before_update :set_number_week
  after_create :check_status

  self.table_name = 'tk_contest_topics'

  has_one_attached :thumbnail

  belongs_to :contest, class_name: "Contest::Contest", foreign_key: 'contest_id'

  has_many :contest_projects, class_name: "Contest::ContestProject", foreign_key: "contest_topic_id"
  has_many :topic_criterions, class_name: "Contest::ContestTopicCriterion", foreign_key: "contest_topic_id"
  has_many :topic_prizes, class_name: "Contest::ContestTopicPrize", foreign_key: 'contest_topic_id'
  has_many :contest_prizes, class_name: "Contest::ContestPrize", through: :topic_prizes
  has_many :contest_criterions, class_name: 'Contest::ContestCriterion', through: :topic_criterions

  def set_number_week
    self.week_number = (self.start_time.strftime('%d').to_i / 7) + 1
    self.week_number = 4 if self.week_number == 5
  end

  def check_status
    if (Time.now > start_time) && (Time.now < end_time)
    contest = Contest::Contest.where(id: self.contest_id).first
    contest&.contest_topics&.update_all(status: 'inactive')
    update(status: 'active')
    else
      update(status: 'inactive')
    end
  end
end
