class SocialCommunity::Photo < ApplicationRecord
  self.table_name = 'photos'
  has_one_attached :image
end
