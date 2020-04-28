class SocialCommunity::Album < ApplicationRecord
  self.table_name = 'albums'
  has_many :photos
  has_many :comments, as: :commentable
  has_many :reactions, as: :reactable
end
