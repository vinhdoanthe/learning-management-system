class SocialCommunity::UserCustomPostContent < ApplicationRecord
  self.table_name = 'user_custome_post_contents'

  has_many :user_shared_photos, class_name: 'SocialCommunity::UserSharedPhoto', foreign_key: 'user_custom_post_content_id', as: :activitiable
end
