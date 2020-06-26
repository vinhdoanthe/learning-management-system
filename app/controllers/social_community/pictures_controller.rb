class SocialCommunity::PicturesController < ApplicationController
  def index
    @pictures = SocialCommunity::Picture.all
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end


  def new
    @picture = SocialCommunity::Picture.new
  end

  def update
  end

  def create
    @picture = SocialCommunity::Picture.new(picture_params)
    if @picture.save
      respond_to do |format|
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }

        format.json { render json: {files: [@picture.to_jq_upload]}, status: :created, location: @picture }

#         format.json {
#           render :json => [@picture.to_jq_upload].to_json
#         }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = SocialCommunity::Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end


  private
  def picture_params
    params.require(:social_community_picture).permit(:avatar)
  end
end
