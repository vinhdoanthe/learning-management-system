class SocialCommunity::Message < ApplicationRecord
  self.table_name = 'messages'
  belongs_to :messageable, polymorphic: true
end
