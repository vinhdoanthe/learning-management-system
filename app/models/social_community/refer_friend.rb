class SocialCommunity::ReferFriend < ApplicationRecord
  self.table_name = 'refer_friends'
  
  extend Enumerize
  
  has_one :post_activity, class_name: 'SocialCommunity::Feed::PostActivity', as: :activitiable

  acts_as_notifiable :users,
    targets: ->(refer, key) {
    (SocialCommunity::ReferFriendsService.get_subscribed_users refer.refer_by).uniq
  }

  def notifiable_path refer, key
    social_community_refer_friends_path
  end

  def create_notifications
    notify :users, key: 'refer.update'
  end
end
