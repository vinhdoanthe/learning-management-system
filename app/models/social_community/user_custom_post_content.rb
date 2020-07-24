class SocialCommunity::UserCustomPostContent < ApplicationRecord
  self.table_name = 'user_custom_post_contents'

  has_many_attached :photos
end
