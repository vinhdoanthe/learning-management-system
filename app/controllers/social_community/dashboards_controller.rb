class SocialCommunity::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_student!, only: [:student_dashboard]
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

  def get_albums_with_comments
    if user.is_student?
      albums_with_comments = SocialCommunity::DashboardsService.get_albums_with_comments user.op_student.id        
    elsif user.is_teacher?

    else

    end

   respond_to do |format|
      format.html
      format.js {render 'albums_with_comment', {albums_with_comments: albums_with_comments}}
   end 
  end

  def teacher_dashboard

  end
end
