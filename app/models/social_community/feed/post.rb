class SocialCommunity::Feed::Post < ApplicationRecord

  self.table_name = 'sc_posts'

  has_many :commentable
  has_many :reactable
end
