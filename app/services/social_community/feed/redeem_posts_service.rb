class SocialCommunity::Feed::RedeemPostsService < SocialCommunity::Feed::PostsService
  def self.get_subscribed_users post_id
    subscribed_users = []

    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: post_id).first
    return [] if post_activity.blank?

    redeem_transaction = Redeem::RedeemTransaction.where(id: post_activity.activitiable_id).first
    return [] if redeem_transaction.blank?
#TODO
    user = User::Account::User.where(id: redeem_transaction.student_id).first
    subscribed_users << user if !user.nil?

    subscribed_users
  end
end
