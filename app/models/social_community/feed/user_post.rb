class SocialCommunity::Feed::UserPost < ApplicationRecord
  self.table_name = 'user_posts'

  belongs_to :user, class_name: 'User::Account::User'
  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::Post'

  def self.create_multiple post_id, user_ids

  end
end
