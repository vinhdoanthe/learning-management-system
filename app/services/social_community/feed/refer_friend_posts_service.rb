class SocialCommunity::Feed::ReferFriendPostsService < SocialCommunity::Feed::PostsService
  def self.get_subscribed_users post_id
    subscribed_users = []

    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: post_id).first
    return [] if post_activity.blank?

    refer = SocialCommunity::ReferFriend.where(id: post_activity.activitiable_id).first
    return [] if refer.blank?

    user = User::Account::User.where(id: refer.refer_by).first
    subscribed_users << user if !user.nil?

    subscribed_users
  end
end
