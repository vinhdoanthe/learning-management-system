class SocialCommunity::Feed::PhotoPost < SocialCommunity::Feed::Post
  has_many :photos, class_name: 'SocialCommunity::Photo', foreign_key: 'sc_post_id'

  acts_as_notifiable :users,
    targets: ->(post, key) {
    (SocialCommunity::Feed::PhotoPostsService.get_subscribed_users post.id).uniq
  },
  notifiable_path: :sc_photo_post_notifiable_path

  def sc_photo_post_notifiable_path
    sc_photo_post_path(id)
  end
end
