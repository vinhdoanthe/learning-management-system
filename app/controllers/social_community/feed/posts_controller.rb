class SocialCommunity::Feed::PostsController < ApplicationController
  before_action :feed_params, only: [:create]
  before_action :get_feed, only: [:show, :delete]

  def index
    @posts = SocialCommunity::Feed::Post.paginate(page: params[:page], per_page: 1).order('created_at DESC')

    respond_to do |format|
      format.html
      format.js {

      }
    end
  end

  # get all related post of a user
  # Params: 
  # user_id
  # time_offset_epoch
  # def get_posts
  #   # permit params
  #   return if !params[:user_id].present? or !params[:time_offset_epoch].present?
  #   user_id = params[:user_id].to_i
  #   time_offset_epoch = params[:time_offset_epoch].to_i
  #   posts, next_time_offset = SocialCommunity::Feed::PostsService.fetch_posts(user_id, time_offset_epoch)
  # end

  def show

  end

  def create

  end

  def delete

  end

  private
  def feed_params

  end

  def get_feed

  end
end
