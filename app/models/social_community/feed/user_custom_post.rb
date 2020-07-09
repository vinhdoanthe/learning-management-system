class SocialCommunity::Feed::UserCustomPost < SocialCommunity::Feed::Post

  has_one :post_activitity, class_name: 'SocialCommunity::Feed::PostActivity', foreign_key: 'sc_post_id'
  has_one :user_custom_post_content, class_name: 'SocialCommunity::UserCustomPostContent', through: :post_activitity
end
