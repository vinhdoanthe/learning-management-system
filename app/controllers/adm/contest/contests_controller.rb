class Adm::Contest::ContestsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:update_contest, :delete_contest]
  before_action :find_contest, only: [:show]

  def index
    @report_title_page = t("Contest.Management contest")

    @contests = Contest::Contest.all
  end

  def show
    @report_title_page = t("Contest.Management contest")
    @contest_topics = @contest.contest_topics
  end

  def update_contest
    result = Adm::Contest::ContestsService.new.update_contest params
    render json: result
  end

  def edit
    @report_title_page = t('Contest.Management contest')
  end

  def new
    @report_title_page = t('Contest.Management contest')
  end

  def delete_contest
    result = Adm::Contest::ContestsService.new.delete_contest params

    render json: result
  end

  def topic_list
    contest = Contest::Contest.where(id: params[:id]).first
    topic_list = contest.contest_topics.where(status: 'active').pluck(:id, :name)

    render json: topic_list
  end

  private

  def find_contest

    @contest = Contest::Contest.where(id: params[:id]).first

    return if @contest.blank?
  end
end
