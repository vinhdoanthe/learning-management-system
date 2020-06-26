class SocialCommunity::Feed::UserCustomPost < SocialCommunity::Feed::Post

  has_many :post_activities, class_name: 'SocialCommunity::Feed::PostActivity', foreign_key: 'sc_post_id'


end
