class SocialCommunity::StudentProject::StudentProjectDecorator < SimpleDelegator

  def youtube_embed_link
    account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
    video = Yt::Video.new id: introduction_video, auth: account
    embed_link = ''
    begin
      embed_link = video.embed_html
    rescue Yt::Errors::NoItems => error
      Rails.logger.error(error.to_s)
      embed_link = ''
    ensure
      # No nothing
    end

    embed_link
  end

  def thumbnail_image_link
    if thumbnail.nil? or thumbnail.empty?
      ActionController::Base.helpers.asset_path('global/images/Bitmap3.png')     
    else
      thumbnail
    end
  end
end
