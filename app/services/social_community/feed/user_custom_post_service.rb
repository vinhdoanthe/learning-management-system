class SocialCommunity::Feed::UserCustomPostService
  def self.create_new_post user_id, content
    if content[:content].empty? and content[:photos].blank?
      post = nil
    else
      post = SocialCommunity::Feed::UserCustomPost.new(posted_by: user_id)
      post_activity = SocialCommunity::Feed::PostActivity.new
      post_content = SocialCommunity::UserCustomPostContent.new(content)
      # ActiveRecord::Base.transaction do
      SocialCommunity::Feed::Post.transaction do
        post.save
        SocialCommunity::UserCustomPostContent.transaction do
          post_content.save
          SocialCommunity::Feed::PostActivity.transaction do
            post_activity.sc_post = post
            post_activity.activitiable = post_content
            post_activity.save
          end
        end
      end 
      SocialCommunity::Feed::UserPostsService.create_multiple(post.id, [user_id])
    end

    post
  end
end
