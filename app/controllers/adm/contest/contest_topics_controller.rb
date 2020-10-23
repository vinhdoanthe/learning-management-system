class Adm::Contest::ContestTopicsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:create_topic, :delete_contest_topic]

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
    if params[:topic_id].present?
      result = Adm::Contest::ContestTopicsService.new.update params
    else
    result = Adm::Contest::ContestTopicsService.new.create_topic params
    end

    respond_to do |format|
      format.html
      format.js { render "adm/contest/contest_topics/create", locals: { result: result } }
    end
  end

  def delete_topic
    result = ''
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    binding.pry
    if topic.blank?
      result = { type: 'danger', message: "chu de k ton tai hoac da bi xoa" }
    else
      if topic.contest_projects.present?
        result = { type: 'danger', message: "khong the xoa chu de vi da co san pham du thi" }
      else
        if topic.delete
          result = { type: 'success', message: 'Xoa thanh cong' }
        else
          result = { type: 'danger', message: 'Da co loi xay ra! thu lai sau' }
        end
      end
    end

    render json: result
  end

  def clone_topic
  end
end
