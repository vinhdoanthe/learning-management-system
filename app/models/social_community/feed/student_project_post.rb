class SocialCommunity::Feed::StudentProjectPost < SocialCommunity::Feed::Post
  has_one :sc_student_project, class_name: 'SocialCommunity::ScStudentProject', foreign_key: 'sc_post_id'

  acts_as_notifiable :users,
    targets: ->(post, key) {
    (SocialCommunity::Feed::StudentProjectPostsService.get_subscribed_users post.id).uniq
  }

  def notifiable_path post, key
    social_community_feed_post_path(id)
  end
end
