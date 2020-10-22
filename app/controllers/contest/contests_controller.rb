class Contest::ContestsController < ApplicationController
  def index
    #@contest = Contest::Contest.where(id: params[:contest_id]).first
    @contest = Contest::Contest.first
  end

  def new
    unless current_user.is_student?
      redirect_to root_path
    else
      #@topic = Contest::ContestTopic.where(id: params[:topic_id]).first
      @topic = Contest::ContestTopic.last
      @contest = @topic&.contest
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
end
