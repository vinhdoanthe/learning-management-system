class Learning::Batch::SessionStudentReward < ApplicationRecord
  self.table_name = 'session_student_rewards'

  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::RewardPost'
end
