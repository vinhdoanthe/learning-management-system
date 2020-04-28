class SocialCommunity::Reaction < ApplicationRecord
  self.table_name = 'reactions'
  belongs_to :reactable, polymorphic: true
end
