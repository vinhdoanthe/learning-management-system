class SocialCommunity::Feed::Post < ApplicationRecord

  self.table_name = 'sc_posts'

  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  def create_notifications
    notify :users, key: 'post.create'
  end
end
