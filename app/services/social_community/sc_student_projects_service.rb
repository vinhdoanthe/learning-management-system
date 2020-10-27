class SocialCommunity::ScStudentProjectsService

  def create_new_student_project params, user
    @params = handling_params params
    result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    project = ''
  #  sc_student_service = SocialCommunity::ScStudentProjectsService.new
    user = User::Account::User.where(student_id: @params[:student_id]).first
    student = user.op_student

    if validate_youtube_upload_params @params
      if validate_subject_project @params
        result = { type: 'danger', message: 'Sản phẩm cuối khoá đã tồn tại! Không thể đăng thêm sản phẩm cuối khoá level này!' }
      else
        if @params[:introduction_video].present? && @params[:name].present?
          video_detail = upload_video_youtube @params[:name], @params[:introduction_video], @params[:description], @params[:batch_id]
          embed_link = video_detail[0]
          thumbnail_video= video_detail[1]
        else
          embed_link = ''
          thumbnail_video = ''
        end

        begin
          project = create_student_project @params, embed_link, user, thumbnail_video
          result = {type: 'success', message: 'Upload thành công'}
        rescue StandardError
          result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
        end

        User::Reward::CoinStarsService.new.reward_coin_star project, user.id, user.id if (user.present? && project.project_type == SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT )
      end
    else
      result = {type: 'danger', message: 'Thiếu thông tin sản phẩm! Vui lòng kiểm tra lại!'}
    end

    [result, project, student]
  end

  def update_student_project params
    result = {}
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

      if params[:student_id].present? && params[:student_id] != project.student_id.to_i
        user = User::Account::User.where(student_id: params[:student_id]).first
        params.merge! ({ user_id: user.id })
      end

      update_attribute = [:introduction_video, :thumbnail, :presentation, :name, :description, :subject_id, :student_id, :user_id, :state, :permission, :project_show_video]
      update_params = {}
      update_attribute.each{ |att| update_params.merge! ({ att => params[att]}) if params[att].present? }

      if params[:project_type] != project.project_type && project.project_type != nil
        if params[:project_type] == SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT
          if (validate_subject_project params) == false
            ActiveRecord::Base.transaction do
              project.update!(update_params)
              project.update!( { project_type: params[:project_type] })
              User::Reward::CoinStarsService.new.reward_coin_star project, project.user_id, project.created_by
            end
            result = { type: 'success', message: 'Update thành công' }
          else
            result = { type: 'danger', message: 'Sản phẩm cuối khoá đã tồn tại' }
          end
        else
          ActiveRecord::Base.transaction do
            project.update!(update_params)
            project.update! ({ project_type: params[:project_type] })
            User::Reward::CoinStarsService.new.create_refund_transaction "SocialCommunity::ScStudentProject", project.user_id, project.created_by
            result = { type: 'success', message: 'Update thành công' }
          end
        end
      else
        project.update! (update_params)
        project.update! ({ project_type: params[:project_type] })
        result = { type: 'success', message: 'Update thành công' }
      end
    rescue StandardError
      result = { type: 'danger', 'message': 'Đã có lỗi xảy ra! Thử lại sau' }
    end

    result
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

  def delete_playlist batch_playlist
    playlist = Yt::Playlist.new id:  batch_playlist.playlist_id
    if playlist.playlist_items.count == 0
      title = playlist.title
      channel = Yt::Channel.new id: Settings.youtube['api_key']
      channel.delete_playlists title: title
      batch_playlist.delete
    end
  end

  def create_student_project params, video_link, teacher, thumbnail_url
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
      project.created_by = teacher.id
      project.project_type = params[:project_type]
      project.image = params[:image]

      user = User::Account::User.where(student_id: params[:student_id]).first
      batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
      course = batch.op_course
      project.course_id = course.id
      project.user_id = user.id 

    ActiveRecord::Base.transaction do
      post = create_project_post teacher, params[:batch_id]
      subscribed_users = SocialCommunity::Feed::StudentProjectPostsService.subscribed_users batch.id
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, subscribed_users
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, [teacher.id]

      project.sc_post_id = post.id

      project.save!
      post.create_notifications
    end

    project
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
      # TODO: temporary load all projects
      # projects = SocialCommunity::ScStudentProject.where(course_id: course_id, permission: 'public').where.not(user_id: user.id).limit(5)
      projects = SocialCommunity::ScStudentProject.where(course_id: course_id).where.not(user_id: user.id).limit(5)
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

  def social_student_projects_content filter_params
    courses = Learning::Course::OpCourse.where(active: true).pluck(:id, :name)

    if filter_params[:course].present? && filter_params[:course] != 'all'
      info = Learning::Course::OpCourse.where(id: filter_params[:course]).order(create_date: :DESC).pluck(:id, :name)
      course_info = { info[0][0] => info[0][1] }
      subjects = Learning::Course::OpSubject.where(course_id: course_info.keys).pluck(:id, :level)
      subjects.sort! { |s| s[1] }
      subjects = subjects.sort
    else
      course_info = {}
      courses.each { |c| course_info.merge!({ c[0] => c[1] })}
      subjects = []
    end
    
    query = ''
    query += "project_show_video IS NOT NULL AND project_show_video <> '' AND " if filter_params[:project_show_video] == '1'
    query += "introduction_video IS NOT NULL AND introduction_video <> '' AND " if filter_params[:introduction_video] == '1'
    query += "project_type = '#{ filter_params[:project_type] }' AND " if ( filter_params[:project_type].present? && filter_params[:project_type] != 'all' )

    if filter_params[:subject].present? && filter_params[:subject] != 'all'
      query += "subject_id IN (#{ filter_params[:subject] }) AND "
    end

    query = query[0..-5]

    if filter_params[:presentation] != '1'
      student_projects = SocialCommunity::ScStudentProject.where(course_id: course_info.keys).where(query).page(filter_params[:page]).per(40)
    else
      student_projects = SocialCommunity::ScStudentProject.where(course_id: course_info.keys).where(query).joins(:presentation_attachment).where.not(presentation_attachment: nil).page(filter_params[:page]).per(40)
    end

    [student_projects, subjects, courses]
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

  def delete_student_project project
    #Xoa post
    begin
      post = SocialCommunity::Feed::Post.where(id: project.sc_post_id).first
      #xoa video youtube(neu co)
      if project.introduction_video.present?
        delete_video_youtube project.introduction_video
        #batch_playlist = SocialCommunity::StudentProjectPlaylist.where(batch_id: project.batch_id).first
        #if batch_playlist.present?
        #  delete_playlist batch_playlist
        #end
      end

      ActiveRecord::Base.transaction do
        post.create_delete_notifications
        project.presentation.purge
        User::Reward::CoinStarsService.new.create_refund_transaction "SocialCommunity::ScStudentProject", project.user_id, project.created_by if project.project_type == SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT
        project.delete
        post.delete
      end

      result = { type: 'success', message: 'Xóa sản phẩm thành công' }
      { result: result, project_id: project.id }
    rescue => e
      puts e
      result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' }
      { result: result, project_id: '' }
    end
  end

  def validate_subject_project params
    SocialCommunity::ScStudentProject.where(project_type: SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT, batch_id: params[:batch_id], subject_id: params[:subject_id], student_id: params[:student_id]).first.present?
  end

  private

  def validate_youtube_upload_params params
    (params[:batch_id].present? && params[:student_id].present? && params[:subject_id].present?) && ((params[:introduction_video].present? && params[:name].present?) || params[:presentation].present? || params[:project_show_video].present? )
  end

  def handling_params params
    @params = {}
    @params.merge! params[:social_community_sc_student_project].permit! if params[:social_community_sc_student_project].present?
    @params.merge! ({ state: params[:state]}) if params[:state].present?
    @params.merge! ({ project_id: params[:project_id]}) if params[:project_id].present?

    if @params['permission'] == '1'
      @params['permission'] = SocialCommunity::Constant::ScStudentProject::Permission::PUBLIC
    end

    @params['state'] = if @params['state'] == '1'
                              SocialCommunity::Constant::ScStudentProject::State::PUBLISH
                            else
                              SocialCommunity::Constant::ScStudentProject::State::DRAFT
                            end

    @params.select! { |k, v| v.present? }
    @params.symbolize_keys!
  end
end
