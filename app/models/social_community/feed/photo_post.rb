class SocialCommunity::Feed::PhotoPost < SocialCommunity::Feed::Post
  has_many :photos, class_name: 'SocialCommunity::Photo', foreign_key: 'sc_post_id'
end
