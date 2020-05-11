class SocialCommunity::Feed::Post < ApplicationRecord

  self.table_name = 'sc_posts'

  has_many :commentable
  has_many :reactable

  def create_notifications
    notify :users, key: 'reward_post.create'
  end
end
