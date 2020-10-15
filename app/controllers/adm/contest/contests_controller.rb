class Adm::Contest::ContestsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:update_contest, :delete_contest]
  before_action :find_contest, only: [:show]

  def index
    @contests = Contest::Contest.all
  end

  def show
    @contest_topics = @contest.contest_topics
  end

  def update_contest
    result = Adm::Contest::ContestsService.new.update_contest params

    render json: result
  end

  def edit
  end

  def delete_contest
    binding.pry
    result = Adm::Contest::ContestsService.new.delete_contest params

    render json: result
  end

  private

  def find_contest
    @contest = Contest::Contest.where(id: params[:id]).first

    return if @contest.blank?
  end
end
