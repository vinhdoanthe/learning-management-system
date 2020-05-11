class SocialCommunity::Feed::RewardPost < SocialCommunity::Feed::Post

  has_one :session_student_reward, class_name: 'Learning::Batch::SessionStudentReward', foreign_key: 'sc_post_id'

end
