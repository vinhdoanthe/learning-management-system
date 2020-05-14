class SocialCommunity::Feed::UserPostsService
  def self.create_multiple sc_post_id, user_ids
    SocialCommunity::Feed::UserPost.transaction do
      user_ids.each do |user_id|
        SocialCommunity::Feed::UserPost.create!(user_id: user_id, sc_post_id: sc_post_id)
      end
    end
  end
end
