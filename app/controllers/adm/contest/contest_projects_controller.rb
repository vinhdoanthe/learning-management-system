class Adm::Contest::ContestProjectsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:update]

  def index
    @contests = Contest::Contest.where(is_publish: true)
    @contest = @contests.where(default: true).first
    @topics = @contest.contest_topics.order(start_time: :DESC)
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

  def update
    topic = Contest::ContestTopic.where(id: params[:contest_topic_id]).first
    project = Contest::ContestProject.where(id: params[:project_id]).first
    if topic.blank?
      result = { type: 'danger', message: 'Topic không tồn tại! Vui lòng thử lại sau!' }
    else
      attributes = project.attribute_names
      attributes.delete('project_id')
      attributes.each do |att|
        if params[att].present?
          project.send(att + '=', params[att])
        end
      end

      if project.save
        result = { type: 'success', message: 'Cập nhật thành công' }
      else
        result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
      end
    end

    render json: result
  end

  def calculate_point
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first

    result = { type: 'success', message: 'Tính điểm thành công' }

    #begin
    Adm::Contest::ContestTopicsService.new.calculate_criterions_point topic, 'MB'
    Adm::Contest::ContestTopicsService.new.calculate_criterions_point topic, 'MN'
    #rescue StandardError => e
    #  result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    #  puts "CONTEST CALCULATE WEEK POINT ERRORS: #{ e } "
    #end

    render json: result
  end

  def award_week_projects
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first

    result = { type: 'success', message: 'Trao giải thành công' }
    result = Adm::Contest::ContestTopicsService.new.calculate_criterions_point topic, 'MB'
    if result[:type] == 'success'
      result = Adm::Contest::ContestTopicsService.new.calculate_criterions_point topic, 'MN'
    end

      result = Adm::Contest::ContestTopicsService.new.awarded_project topic, params[:type], 'MB'
      result = Adm::Contest::ContestTopicsService.new.awarded_project topic, params[:type], 'MN'

    render json: result
  end
end
