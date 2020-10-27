class Contest::ContestProject < ApplicationRecord
  before_create :default_values

  self.table_name = "tk_contest_projects"

  belongs_to :contest_topic, class_name: "Contest::ContestTopic", foreign_key: "contest_topic_id"
  belongs_to :contest, class_name: "Contest::Contest", foreign_key: "contest_id"
  belongs_to :user, class_name: "User::Account::User", foreign_key: "user_id"
  belongs_to :student_project, class_name: 'SocialCommunity::ScStudentProject', foreign_key: 'project_id'

  has_many :project_criterions, class_name: 'Contest::ProjectCriterion', foreign_key: "contest_project_id"
  has_many :contest_criterions, class_name: 'Contest::ContestCriterion', through: :project_criterions

  belongs_to :contest_prize, class_name: "Contest::ContestPrize", foreign_key: "contest_prize_id"

  private
    def default_values
      self.score ||= 0
      self.judges_score ||= 0
      self.views ||= 0
    end
end
