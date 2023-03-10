class SocialCommunity::Feed::Post < ApplicationRecord

  self.table_name = 'sc_posts'

  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable

  belongs_to :posted_user, class_name: 'User::Account::User', foreign_key: 'posted_by'

  def create_notifications
    notify :users, key: 'post.create'
  end

  def create_update_notifications
    notify :users, key: 'post.update'
  end

  def create_delete_notifications
    notify :users, key: 'post.delete'
  end
end
