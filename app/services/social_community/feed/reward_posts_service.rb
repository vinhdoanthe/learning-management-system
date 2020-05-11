class SocialCommunity::Feed::RewardPostsService < SocialCommunity::Feed::PostsService
  def self.get_subscribed_users post_id
    subscribed_users = []

    related_users = Learning::Batch::SessionStudentReward.where(sc_post_id: post_id).first.select(:reward_by, :reward_to)
    if !related_users.nil?
      reward_by_user = User::Account::User.where(id: related_users[:reward_by]).first
      subscribed_users << reward_by_user if !reward_by_user.nil?
      reward_to_user = User::Account::User.where(id: related_users[:reward_to]).first
      subscribed_users << reward_to_user if !reward_to_user.nil?
    end

    subscribed_users
  end
end
