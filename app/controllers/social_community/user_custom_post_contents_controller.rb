class SocialCommunity::UserCustomPostContentsController < ApplicationController

  def create
    @post = SocialCommunity::UserCustomPostContent.new(post_params)
    if @post.save
      # TODO:
      # create related information 
      # render new post
      # clear post content
    else
      # render errors
    end
  end

  private
  def post_params
    params.permit(:content, :photos => [])
  end
end
