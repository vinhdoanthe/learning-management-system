class SocialCommunity::Message < ApplicationRecord
  self.table_name = 'messages'
  belongs_to :conversation, foreign_key: 'conversation_id'
end
