class SocialCommunity::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_student!, only: [:student_dashboard, :student_coming_soon_session]
  before_action :authenticate_faculty!, only: [:teacher_dashboard]

  def student_dashboard
    @student = User::OpenEducat::OpStudent.where(id: current_user.student_id).first
    # Load albums
    # Load rewards
    # Load conversations
    # Load coming sessions
    # Load notifications
    # Load point, stars
    # Load attendance report
    # Load leaders board
  end

  # params
  # user
  # post_offset
  # last_post_date_time
  def new_feeds
    @feeds = SocialCommunity::Feed::PostsService.new_feeds params
    respond_to do |format|
      format.html
      format.js {
        render 'social_community/feed/posts/new_feed'
      }
    end
  end

  # get posts related to users
  # Params:
  # user
  # time_offset
  # Return:
  # posts
  # next_time_offset
  def home_feeds
    #    if current_user.is_student?    
    if params[:time_offset_epoch].present?
      time_offset_epoch = DateTime.parse(params[:time_offset_epoch])
      p time_offset_epoch
    else
      time_offset_epoch = DateTime.now
    end
    @feeds, @next_time_offset = SocialCommunity::Feed::PostsService.fetch_feeds(current_user.id, time_offset_epoch) 
    #   elsif current_user.is_teacher?
    # TODO
    # end
    respond_to do |format|
      format.html
      format.js {
        render 'social_community/feed/posts/index'
      }
    end
  end

  def albums_with_comments
    if current_user.is_student?
      albums_with_comments = SocialCommunity::DashboardsService.get_student_albums_with_comments current_user.student_id
    elsif current_user.is_teacher?

    else

    end

    respond_to do |format|
      format.html
      format.js {render 'social_community/dashboards/shared/js/albums_with_comments', :locals => {albums_with_comments: albums_with_comments}}
    end 
  end

  def student_coming_soon_session
    @student = User::OpenEducat::OpStudent.where(id: current_user.student_id).first
    session = User::OpenEducat::OpStudentsService.get_comming_soon_session(@student.id)
    coming_soon_session_decor = SocialCommunity::DashboardsService.coming_session_decorator session
    respond_to do |format|
      format.html
      format.js {render 'social_community/dashboards/student/js/coming_soon', :locals => {coming_soon_session: coming_soon_session_decor}}
    end
  end

  def dashboard_noti
    notices = Notification::BroadcastNoti.order(created_at: :DESC).limit(3)

    respond_to do |format| 
      format.html
      format.js { render 'social_community/dashboards/student/js/dashboard_noti', locals: { notices: notices } }
    end 
  end

  def leaders
      @leaders, @offset = SocialCommunity::DashboardsService.leaders(params[:page])
  end

  def leader_board
    @leaders = SocialCommunity::DashboardsService.community_leaders
    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/student/js/dashboard_leader', locals: { leaders: @leaders } }
    end
  end

  def teacher_dashboard

  end

  def teacher_coming_soon_sessions
    teacher = current_user.op_faculty
    coming_soon_sessions = teacher.op_sessions.joins(:op_batch).where(op_batch: { state: Learning::Constant::Batch::STATE_APPROVE }).where(start_datetime: Time.now..(Time.now + 30.days)).where.not(state: Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC).limit(3)

    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/teacher/js/comming_soon', locals: { coming_soon_sessions: coming_soon_sessions } }
    end
  end

  def dashboard_photos
    photos = []
    post = SocialCommunity::Feed::Post.where(id: params[:post_id]).first

    if post.type == "SocialCommunity::Feed::PhotoPost"
      social_photos = post.photos
      social_photos.each do |photo|
        photos << photo.image
      end
    elsif post.type == 'SocialCommunity::Feed::UserCustomPost'
      post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: params[:post_id]).first
      photos = post_activity.activitiable.photos
    end

    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/shared/js/dashboard_photo_modal_content', locals: { photos: photos } }
    end
  end
end
