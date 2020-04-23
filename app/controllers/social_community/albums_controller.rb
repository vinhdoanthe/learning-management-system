class SocialCommunity::AlbumsController < ApplicationController
  before_action :get_album, only: [:create, :destroy, :add_photo]

  def new

  end

  def create

  end

  def destroy

  end

  def add_photo

  end

  private

  def get_album
    if params[:album_id].present?
      @album = Album.where(id: params[:album_id]).first
    else
      @album = nil
    end
  end
end
