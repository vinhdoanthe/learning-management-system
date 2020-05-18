class SocialCommunity::Feed::RewardPost < SocialCommunity::Feed::Post

  has_one :session_student_reward, class_name: 'Learning::Batch::SessionStudentReward', foreign_key: 'sc_post_id'

 # acts_as_notifiable configures your model as ActivityNotification::Notifiable
  # with parameters as value or custom methods defined in your model as lambda or symbol.
  # The first argument is the plural symbol name of your target model.
  acts_as_notifiable :users,
    # Notification targets as :targets is a necessary option
    # Set to notify to author and users commented to the article, except comment owner self
    targets: ->(post, key) {
      (SocialCommunity::Feed::RewardPostsService.get_subscribed_users(post.id)).uniq
      # ([comment.article.user] + comment.article.commented_users.to_a - [comment.user]).uniq
    }
    # Path to move when the notification is opened by the target user
    # This is an optional configuration since activity_notification uses polymorphic_path as default
    # notifiable_path: :sc_reward_post_notifiable_path

  def notifiable_path post, key
    social_community_feed_post_path(id)
  end
  
end
