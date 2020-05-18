class SocialCommunity::Feed::PostsController < ApplicationController
  before_action :feed_params, only: [:create]
  before_action :get_post, only: [:show, :delete, :add_reaction, :add_comment]

  def index
    @posts = SocialCommunity::Feed::Post.paginate(page: params[:page], per_page: 1).order('created_at DESC')

    respond_to do |format|
      format.html
      format.js {

      }
    end
  end

  def add_reaction
    unless @post.nil? and !params[:reaction_type].present?
      reaction_type = params[:reaction_type].to_i
      if (reaction_type == SocialCommunity::Constant::ReactionType::LIKE \
          or reaction_type == SocialCommunity::Constant::ReactionType::LOVE \
          or reaction_type == SocialCommunity::Constant::ReactionType::SAD)
        reaction = SocialCommunity::Reaction.new(reactable: @post)
        reaction.react_type = params[:reaction_type]
        reaction.reacted_by = current_user.id
        reaction.save
        count_like = nil
        count_love = nil
        count_sad = nil
        if reaction_type == SocialCommunity::Constant::ReactionType::LIKE
          count_like = SocialCommunity::Feed::PostsService.count_like @post
        elsif reaction_type == SocialCommunity::Constant::ReactionType::LOVE
          count_love = SocialCommunity::Feed::PostsService.count_love @post
        elsif reaction_type == SocialCommunity::Constant::ReactionType::SAD
          count_sad = SocialCommunity::Feed::PostsService.count_sad @post
        end
        respond_to do |format|
          format.html

          format.js {render 'social_community/dashboards/shared/posts/js/update_reactions', :locals => {post_id: @post.id, count_like: count_like, count_love: count_love, count_sad: count_sad}}
        end
      end
    end
  end

  def add_comment
    return if current_user.nil?
    unless @post.nil? and !params[:content].present?
      comment_content = params[:content].to_s
      return if comment_content.blank?
      comment = SocialCommunity::Comment.new(commentable: @post)
      comment.commented_by = current_user.id
      comment.content = comment_content
      comment.save
      comment_decor = SocialCommunity::CommentsService.comment_decorator comment
   
      respond_to do |format|
        format.html
        format.js {render 'social_community/dashboards/shared/posts/js/update_comments', :locals => {post_id: @post.id, comment: comment_decor}}
      end
    end
  end

  def show
    @feeds = SocialCommunity::Feed::PostsService.decor_post_to_feed [@post]
  end

  def create

  end

  def delete

  end

  private
  def feed_params

  end

  def get_post
    if !params[:post_id].nil?
      @post = SocialCommunity::Feed::Post.where(id: params[:post_id]).first
    elsif params[:id].present?
      @post = SocialCommunity::Feed::Post.where(id: params[:id]).first
    else
      @post = nil
    end
  end
end
