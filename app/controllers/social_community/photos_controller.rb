class SocialCommunity::PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:delete_session_photo]
  def new

  end

  def create

  end

  def destroy

  end

  def delete_session_photo
    photo = SocialCommunity::Photo.where(id: params[:photo_id]).first
    if photo.delete
      render json: { type: 'success', message: 'Xoá ảnh thành công' }
    else
      render json: { type: 'danger', message: 'Có lỗi xảy ra! Thử lại sau!' }
    end
  end

end
