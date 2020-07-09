class SocialCommunity::UserSharedPhotosController < ApplicationController
  def index
    @photos = SocialCommunity::UserSharedPhoto.all
    render :json => @photos.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @photo = SocialCommunity::UserSharedPhoto.new(params[:SocialCommunity::UserSharedPhoto])
    if @photo.save
      respond_to do |format|
        format.html {  
          render :json => [@photo.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json { 
          render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo 
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @photo = SocialCommunity::UserSharedPhoto.find(params[:id])
    @photo.destroy
    render :json => true
  end

  private
  def photo_params
    params.require(:social_community_user_shared_photo).permit(:image)
  end
end
