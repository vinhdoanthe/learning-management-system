class Learning::Batch::SessionStudentReward < ApplicationRecord
  self.table_name = 'session_student_rewards'

  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::RewardPost'
  belongs_to :reward_type, class_name: 'Common::RewardType'
  belongs_to :rewarded_user, class_name: 'User::Account::User', foreign_key: 'rewarded_to'
  belongs_to :op_session, class_name: 'Learning::Batch::OpSession', foreign_key: 'session_id'
end
