class SocialCommunity::Feed::RedeemPost < SocialCommunity::Feed::Post

  acts_as_notifiable :users,
    targets: ->(post, key) {
      (SocialCommunity::Feed::RedeemPostsService.get_subscribed_users(post.id)).uniq
    }

  def notifiable_path post, key
    social_community_feed_post_path(id)
  end
  
end
