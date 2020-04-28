class SocialCommunity::Comment < ApplicationRecord
  self.table_name = 'comments'
  belongs_to :commentable, polymorphic: true
end
