class SocialCommunity::Feed::UserPostsService
  def self.create_multiple sc_post_id, user_ids
    SocialCommunity::Feed::UserPost.transaction do
      user_ids.each do |user_id|
        user_post = SocialCommunity::Feed::UserPost.where(user_id: user_id, sc_post_id: sc_post_id).first
        if user_post.nil?
          SocialCommunity::Feed::UserPost.create!(user_id: user_id, sc_post_id: sc_post_id)
        end
      end
    end
  end
end
