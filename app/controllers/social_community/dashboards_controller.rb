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

  def new_user
    users = User::Account::User.where(account_role: 'Student').order(created_at: :DESC).limit(10)
    students = []
    users.each{ |user| students << user.op_student }

    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/student/js/dashboard_leader', locals: { students: students } }
    end
  end

  def teacher_dashboard

  end
end
