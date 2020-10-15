class Contest::ContestProject < ApplicationRecord
  self.table_name = "tk_contest_projects"

  belongs_to :contest_topic, class_name: "Contest::ContestTopic", foreign_key: "contest_topic_id"
  belongs_to :contest, class_name: "Contest::Contest", foreign_key: "contest_id"
  belongs_to :users, class_name: "User::Account::User", foreign_key: "user_id"

end
