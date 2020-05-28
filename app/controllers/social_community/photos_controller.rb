class SocialCommunity::PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:delete_session_photo]
  def new

  end

  def create

  end

  def destroy

  end

  def delete_session_photo
    result = SocialCommunity::PhotoService.new.delete_photo params[:photo_id]
    render json: result
  end

end
