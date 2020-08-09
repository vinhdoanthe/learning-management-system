class SocialCommunity::ScStudentProjectsService

  def update_student_project params
    project = SocialCommunity::ScStudentProject.where(id: params[:project_id]).first

    begin
      if params[:introduction_video].present? && params[:change_video] == '1'
        title = params[:name] || project.name
        description ||= params[:description] || project.description
        video_detail = upload_video_youtube title, params[:introduction_video], description, params[:batch_id]
        params.merge! ({ introduction_video: video_detail[0], thumbnail: video_detail[1] })
        video_id = project.introduction_video

        if video_id.present?
          delete_video_youtube video_id
        end
      end

      if params[:student_id].present? && params[:student_id] != project.student_id
        user = User::Account::User.where(student_id: params[:student_id]).first
        params.merge! ({ user_id: user.id })
      end

      update_attribute = [:introduction_video, :thumbnail, :presentation, :name, :description, :subject_id, :student_id, :user_id, :state, :permission, :project_show_video]
      update_params = {}
      update_attribute.each{ |att| update_params.merge! ({ att => params[att]}) if params[att].present? }

      if project.update!(update_params)
        { type: 'success', 'message': 'Update thành công' }
      else
        { type: 'danger', 'message': 'Đã có lỗi xảy ra! Thử lại sau' }
      end
    rescue StandardError => e
      return { type: 'danger', 'message': 'Đã có lỗi xảy ra! Thử lại sau' }
    end
  end

  def delete_video_youtube video_id
    account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
    video = Yt::Video.new id: video_id, auth: account
    begin
      video.delete
    rescue Yt::Errors::RequestError => error
      Rails.logger.error(error.to_s)
    ensure
      # do nothing
    end
  end

  def upload_video_youtube title, file, description, batch_id
    account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
    file = file.try(:tempfile).try(:to_path)

    begin 
      new_video = account.upload_video file, title: title, privacy_status: 'unlisted'
      video_id = new_video.id
      video = Yt::Video.new id: video_id, auth: account
      embed_link = video_id
      thumbnail_video = video.thumbnail_url
      manage_youtube_playlist account, batch_id, video_id
    rescue Yt::Errors => error
      Rails.logger.error(error.to_s)
      embed_link = ''
      thumbnail_video = ''
    ensure
    end

    [embed_link, thumbnail_video]
  end

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
      project.presentation = params[:presentation]
      project.project_show_video = params[:project_show_video]
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

  def social_student_projects user
    # TODO: tuning SQL Query
    course_ids = SocialCommunity::ScStudentProject.all.pluck(:course_id).uniq
    course_projects = []
    course_ids.each do |course_id|
      projects = SocialCommunity::ScStudentProject.where(course_id: course_id, permission: 'public').where.not(user_id: user.id).limit(4)
      course_projects << (get_course_projects_hash projects)
    end

    if user.is_student?
      projects = SocialCommunity::ScStudentProject.where(user_id: user.id).all
      student_projects = (get_course_projects_hash projects)
      
    elsif user.is_teacher?
      student_projects = []
    else
      student_projects = []
    end

    [student_projects, course_projects]
  end

  def get_course_projects_hash projects
    course_hash = {}
    projects.each do |project|
      course = project.op_course
      if course_hash[course].present?
        course_hash[course] << project
      else
        course_hash[course] = [project]
      end
    end

    course_hash
  end
end
