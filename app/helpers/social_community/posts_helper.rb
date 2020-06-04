module SocialCommunity::PostsHelper
  def count_post_comments post
    post.comments.count
  end

  def count_post_reactions post
    post.reactions.count
  end
end
  
