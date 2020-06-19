class SocialCommunity::StudentProject::StudentProjectDecorator < SimpleDelegator
  def youtube_embed_link
    account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
    video = Yt::Video.new id: introduction_video, auth: account
    video.embed_html
  end
end
