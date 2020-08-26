include ReferFriendConstants

class SocialCommunity::ReferFriend < ApplicationRecord
  self.table_name = 'refer_friends'

  has_paper_trail

  extend Enumerize

  belongs_to :user, class_name: 'User::Account::User', foreign_key: :refer_by
  belongs_to :crm_lead, class_name: "Crm::Lead", foreign_key: :crm_lead_id, required: false

  has_one :post_activity, class_name: 'SocialCommunity::Feed::PostActivity', as: :activitiable

  enumerize :state, in: REFER_FRIEND_STATES

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

  def state_waiting?
    state == REFER_FRIEND_STATE_WAITING
  end

  def state_confirm?
    state == REFER_FRIEND_STATE_CONFIRM
  end

  def state_succeed?
    state == REFER_FRIEND_STATE_SUCCEED
  end

  def state_failed?
    state == REFER_FRIEND_STATE_FAILED
  end
end
