class Learning::Batch::SessionStudentReward < ApplicationRecord
  self.table_name = 'session_student_rewards'

  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::RewardPost'
  belongs_to :reward_type, class_name: 'Common::RewardType'
end
