class Adm::Contest::ContestTopicsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:create_topic]

  def index
  end

  def new
  end

  def edit
  end

  def show
    @topic = Contest::ContestTopic.where(id: params[:id]).first
    @contest = Contest::Contest.where(id: @topic.contest_id).first
  end

  def create_topic
    result = Adm::Contest::ContestTopicsService.new.create_topic params

    respond_to do |format|
      format.html
      format.js { render "adm/contest/contest_topics/create", locals: { result: result } }
    end
  end

  def clone_topic
  end
end
