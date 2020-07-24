class SocialCommunity::UserCustomPostContentsController < ApplicationController

  def create
    post = SocialCommunity::Feed::UserCustomPostService.create_new_post(current_user.id, post_params)
    if !post.nil?
      # TODO:
      # create related information 
      # render new post
      feed = SocialCommunity::Feed::PostsService.decor_post_to_feed([post]).first

      respond_to do |format|
        format.html
        format.js {
          render 'social_community/dashboards/shared/js/add_new_user_custom_post', :locals => {feed: feed}
        }
      end
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
