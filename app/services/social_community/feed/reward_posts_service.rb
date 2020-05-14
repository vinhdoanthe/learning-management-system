class SocialCommunity::Feed::RewardPostsService < SocialCommunity::Feed::PostsService
  @reward_post = SocialCommunity::Feed::RewardPost.new
  def self.get_subscribed_users post_id
    subscribed_users = []

    related_users = Learning::Batch::SessionStudentReward.where(sc_post_id: post_id).select(:rewarded_by, :rewarded_to).first
    if !related_users.nil?
      reward_by_user = User::Account::User.where(id: related_users[:rewarded_by]).first
      subscribed_users << reward_by_user if !reward_by_user.nil?
      reward_to_user = User::Account::User.where(id: related_users[:rewarded_to]).first
      subscribed_users << reward_to_user if !reward_to_user.nil?
    end

    subscribed_users
  end

  def decor_post_to_feed
    
  end
end
