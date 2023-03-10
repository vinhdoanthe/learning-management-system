class Contest::ContestsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :leader_board, :award, :week_award_content]
  before_action :find_contest, except: [:week_award_content, :leader_board]

  def index
    @topic = @contest.contest_topics.where(status: 'active').first

    if @topic.present?
      @month_prize = @contest.contest_prizes.where(prize_type: 'm', prize: 1).first
      @prize = @topic.contest_prizes.where(prize_type: 'w', prize: 1).first
      @result = Contest::ContestTopicsService.new.contest_month_topic @contest.id
    else
      flash[:danger] = "Chưa có cuộc thi nào diễn ra!"
      redirect_to root_path
    end
  end

  def new
    unless current_user.is_student?
      redirect_to root_path
    else
      #@contest = Contest::Contest.where(id: params[:contest_id]).first
      redirect_to root_path if @contest.blank?

      @topic = @contest.contest_topics.where(status: 'active').first
      @student = current_user.op_student

      teacher_ids = @student.op_sessions.pluck(:faculty_id).uniq
      teachers = User::OpenEducat::OpFaculty.where(id: teacher_ids).pluck(:id, :full_name)
      @teachers = {}
      teachers.each do |t|
        @teachers.merge! ( { t[1] => t[0] })
      end

      batch_ids = Learning::Batch::OpStudentCourse.joins(:op_subjects).where(student_id: @student.id).where.not(op_subject: { id: nil}).pluck(:batch_id)
      batches = Learning::Batch::OpBatch.joins(:op_course).where(id: batch_ids).pluck(:id, 'op_course.name')
      @project_type = [SocialCommunity::Constant::ScStudentProject::ProjectType::SESSION_PROJECT, SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT]
      @batches = {}

      batches.each do |batch|
        @batches.merge! ({ batch[1] => batch[0] })
      end

      if @batches.blank?
        flash[:danger] = "Bạn chưa tham gia lớp học nào!"
        redirect_to root_path 
      end

      if params[:type] == 'edit' && params[:project_id].present?
        @c_project = Contest::ContestProject.where(project_id: params[:project_id]).first
        @project = SocialCommunity::ScStudentProject.where(id: @c_project.project_id).first
        @topic = @c_project.contest_topic

        respond_to do |format|
          format.html
          format.js { render 'contest/contest_projects/edit' }
        end
      end
    end
  end

  def submit_contest
    result = Adm::Contest::ContestProjectsSevice.new.create_contest_project params

    respond_to do |format|
      format.html
      format.js { render "", locals: { result: result } }
    end
  end

  def leader_board
    week_projects, month_project, contest = Contest::ContestsService.new.leader_board params[:contest_id]

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/leader_board', locals: { month_project: month_project, week_projects: week_projects, contest: contest } }
    end
  end

  def award
    @month_projects = Contest::ContestsService.new.awarded_projects @contest, 'm', ''
    @month_details = {}
    @month_projects.each do |project|
      @month_details.merge! ({ project.id => ( Contest::ContestsService.new.contest_project_detail project )})
    end
  end

  def week_award_content
    @contest = Contest::Contest.where(id: params[:contest_id]).first
    @week_projects = Contest::ContestsService.new.awarded_projects @contest, 'w', params[:page]
    @week_details = {}
    @week_projects.each do |project|
      @week_details.merge! ({ project.id => ( Contest::ContestsService.new.contest_project_detail project )})
    end
  end

  def award_month_prize_info
    result = Contest::ContestsService.new.award_month_prize_info @contest, params

    respond_to do |format|
      format.html
      format.js { render 'adm/contest/contest_projects/award_month_prize_details', locals: result }
    end
  end

  def award_month_prize
    result = Contest::ContestsService.new.award_month_prize @contest, params

    render json: result
  end

  private

  def find_contest
    if params[:contest_alias].present?
      @contest = Contest::Contest.where(alias_name: params[:contest_alias]).first
    elsif params[:contest_id].present?
      @contest = Contest::Contest.where(id: params[:contest_id]).first
    end

    redirect_to root_path if @contest.blank?
  end
end
