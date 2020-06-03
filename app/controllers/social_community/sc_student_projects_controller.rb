class SocialCommunity::ScStudentProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def youtube_upload
    if validate_youtube_upload_params params
      account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
      file = params[:file].try(:tempfile).try(:to_path)
      new_video = account.upload_video file, title: params[:title], description: params[:description]
      video_id = new_video.id
      video = Yt::Video.new id: video_id
      embed_link = video.embed_html
      SocialCommunity::ScStudentProjectsService.new.manage_youtube_playlist account, params[:batch_id], video_id
      SocialCommunity::ScStudentProjectsService.new.create_student_project params, embed_link, current_user
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', params[:student_id], 'coin', current_user.id
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', params[:student_id], 'star', current_user.id
    end
  end

  def validate_youtube_upload_params params
    params[:file].present? && params[:title].present? && params[:batch_id].present? && params[:student_id].present? && params[:subject_id].present?
  end
end
