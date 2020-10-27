class Contest::ContestsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :leader_board]

  def index
    @contest = Contest::Contest.where(id: params[:id]).first
    @topic = @contest.contest_topics.where(status: 'active').first
    @month_prize = @topic.contest_prizes.where(prize_type: 'm', prize: 1).first
    @prize = @topic.contest_prizes.where(prize_type: 'w', prize: 1).first
    @result = Contest::ContestTopicsService.new.contest_month_topic @contest.id
  end

  def new
    unless current_user.is_student?
      redirect_to root_path
    else
      @contest = Contest::Contest.where(id: params[:id]).first
      redirect_to root_path if @contest.blank?

      @topic = @contest.contest_topics.where(status: 'active').first
      @student = current_user.op_student
      batch_ids = Learning::Batch::OpStudentCourse.joins(:op_subjects).where(student_id: @student.id).where.not(op_subject: { id: nil}).pluck(:batch_id)
      batches = Learning::Batch::OpBatch.joins(:op_course).where(id: batch_ids).pluck(:id, 'op_course.name')
      @project_type = [SocialCommunity::Constant::ScStudentProject::ProjectType::SESSION_PROJECT, SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT]
      @batches = {}
      batches.each do |batch|
        @batches.merge! ({ batch[1] => batch[0] })
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
    week_projects, month_project = Contest::ContestsService.new.leader_board params[:contest_id]

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/leader_board', locals: { month_project: month_project, week_projects: week_projects } }
    end
  end

  def award
    #week_projects, month_project = Contest::ContestsService.new.leader_board params[:contest_id]
  end
end
