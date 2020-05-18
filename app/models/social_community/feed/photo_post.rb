class SocialCommunity::Feed::PhotoPost < SocialCommunity::Feed::Post
  has_many :photos, class_name: 'SocialCommunity::Photo', foreign_key: 'sc_post_id'

  acts_as_notifiable :users,
    targets: ->(post, key) {
    (SocialCommunity::Feed::PhotoPostsService.get_subscribed_users post.id).uniq
  }

  def notifiable_path post, key
    social_community_feed_post_path(id)
  end
end
