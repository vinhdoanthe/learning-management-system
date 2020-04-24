class SocialCommunity::Conversation < ApplicationRecord
  self.table_name = 'conversations'
  has_many :messages, as: :messageable
end
