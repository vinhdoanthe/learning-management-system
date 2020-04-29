class SocialCommunity::AlbumsController < ApplicationController
  before_action :get_album, only: [:create, :destroy, :add_photo, :add_reaction, :add_comment]

  def new

  end

  def create

  end

  def destroy

  end

  def add_photo

  end

  # Add comments
  # Params:
  # album_id
  # content
  def add_comment
    return if current_user.nil?
    unless @album.nil? and !params[:content].present?
      comment_content = params[:content].to_s
      return if comment_content.blank?
      comment = SocialCommunity::Comment.new(commentable: @album)
      comment.commented_by = current_user.id
      comment.content = comment_content
      comment.save
      comment_decor = SocialCommunity::CommentsService.comment_decorator comment
      respond_to do |format|
        format.html
        format.js {render 'social_community/dashboards/shared/js/update_comments', :locals => {album_id: @album.id, comment: comment_decor}}
      end
    end
  end

  # Add reactions
  # Params:
  # album_id
  # react_type
  def add_reaction
    # Add to DB
    unless @album.nil? and !params[:reaction_type].present?
      reaction_type = params[:reaction_type].to_i
      if (reaction_type == SocialCommunity::Constant::ReactionType::LIKE \
          or reaction_type == SocialCommunity::Constant::ReactionType::LOVE \
          or reaction_type == SocialCommunity::Constant::ReactionType::SAD)
        reaction = SocialCommunity::Reaction.new(reactable: @album)
        reaction.react_type = params[:reaction_type]
        reaction.reacted_by = current_user.id
        reaction.save
        count_like = nil
        count_love = nil
        count_sad = nil
        if reaction_type == SocialCommunity::Constant::ReactionType::LIKE
          count_like = SocialCommunity::AlbumsService.count_like @album.id
        elsif reaction_type == SocialCommunity::Constant::ReactionType::LOVE
          count_love = SocialCommunity::AlbumsService.count_love @album.id
        elsif reaction_type == SocialCommunity::Constant::ReactionType::SAD
          count_sad = SocialCommunity::AlbumsService.count_sad @album.id
        end
        respond_to do |format|
          format.html
          format.js {render 'social_community/dashboards/shared/js/update_reactions', :locals => {album_id: @album.id, count_like: count_like, count_love: count_love, count_sad: count_sad}}
        end
      end
    end
  end

  private

  def get_album
    if params[:album_id].present?
      @album = SocialCommunity::Album.where(id: params[:album_id]).first
    else
      @album = nil
    end
  end
end
