class SocialCommunity::ScStudentProjectsService

  def manage_youtube_playlist account, batch_id, video_id
    playlist_id = ''
    batch_playlist = SocialCommunity::StudentProjectPlaylist.where(batch_id: batch_id).first
    if batch_playlist.blank?
      playlist = create_youtube_playlist account, batch_id
      playlist_id = playlist.id
    end
    
    playlist_id = batch_playlist.playlist_id if playlist_id.blank?
    add_video_to_playlist account, playlist_id, video_id
  end

  def add_video_to_playlist account, playlist_id, video_id
    playlist = Yt::Playlist.new id:  playlist_id, auth: account
    playlist.add_video video_id
  end

  def create_youtube_playlist account, batch_id
    batch = Learning::Batch::OpBatch.where(id: batch_id).first
    course_name = batch.op_course.name
    name = "Khoá học #{ course_name } - Lớp #{ batch.name }"
    playlist = account.create_playlist title: name
    SocialCommunity::StudentProjectPlaylist.create(batch_id: batch_id, playlist_id: playlist.id)
    playlist
  end

  def create_student_project params, video_link, teacher, thumbnail_url
    ActiveRecord::Base.transaction do
      project = SocialCommunity::ScStudentProject.new
      project.description = params[:description]
      project.name = params[:name]
      project.presentation = params[:slide]
      project.project_show_video = params[:tinker]
      project.introduction_video = video_link
      project.batch_id = params[:batch_id]
      project.thumbnail = thumbnail_url
      project.subject_id = params[:subject_id]
      project.student_id = params[:student_id]
      
      user = User::Account::User.where(student_id: params[:student_id]).first
      batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
      course = batch.op_course
      project.course_id = course.id
      project.user_id = user.id 

      post = create_project_post teacher, params[:batch_id]
      subscribed_users = SocialCommunity::Feed::StudentProjectPostsService.subscribed_users batch.id
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, subscribed_users
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, [teacher.id]

      project.sc_post_id = post.id

      project.save!
      post.create_notifications
    end
  end

  def create_project_post teacher, batch_id
    post = SocialCommunity::Feed::StudentProjectPost.new
    post.posted_by = teacher.id
    post.batch_id = batch_id
    post.save
    post
  end
end
