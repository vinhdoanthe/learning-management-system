class SocialCommunity::Feed::RewardPost < SocialCommunity::Feed::Post

  has_one :session_student_reward, class_name: 'Learning::Batch::SessionStudentReward', foreign_key: 'sc_post_id'

  acts_as_notifiable :users,
    targets: ->(post, key) {
      (SocialCommunity::Feed::RewardPostsService.get_subscribed_users(post.id)).uniq
    }

  def notifiable_path post, key
    social_community_feed_post_path(id)
  end
  
end
