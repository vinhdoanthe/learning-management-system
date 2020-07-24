class SocialCommunity::UserCustomPostContent < ApplicationRecord
  self.table_name = 'user_custom_post_contents'

  has_many_attached :photos
  has_one :post_activity, class_name: 'SocialCommunity::Feed::PostActivity', as: :activitiable
end
