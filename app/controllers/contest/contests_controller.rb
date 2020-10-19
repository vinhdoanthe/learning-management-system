class Contest::ContestsController < ApplicationController
  def index
  end

  def new
    @topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    @contest = @topic&.contest
  end

  def submit_contest
    result = Adm::Contest::ContestProjectsSevice.new.create_contest_project params
    
    respond_to do |format|
      format.html
      format.js { render "", locals: { result: result } }
    end
  end

  def prepare_submit_contest
    redirect_to root_path
  end
end
