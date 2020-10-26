class Adm::Contest::ContestProjectsController < Adm::AdmController

  def index
    @contests = Contest::Contest.where(is_publish: true)
    @contest = @contests.first
    @topics = @contest.contest_topics.where(status: 'active')
  end

  def index_content
    contest, topic, c_projects_detail, projects_detail = Adm::Contest::ContestProjectsService.new.index_content params

    respond_to do |format|
      format.html
      format.js { render 'adm/contest/contest_projects/index', locals: { contest: contest, topic: topic, projects: projects_detail, c_projects: c_projects_detail } }
    end
  end

  def show
  end

  def calculate_point
    #binding.pry
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    result = Adm::Contest::ContestTopicsService.new.calculate_criterions_point topic

    if result[:type] == 'success'
      result = Adm::Contest::ContestTopicsService.new.awarded_project topic, params[:type]
    end

    render json: result
  end
end
