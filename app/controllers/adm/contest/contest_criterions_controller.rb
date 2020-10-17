class Adm::Contest::ContestCriterionsController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:create_criterion]
  def new
  end

  def create_criterion
    result = Adm::Contest::ContestCriterionsService.new.create_criterion params

    respond_to do |format|
      format.html
      format.js { render 'adm/contest/contest_criterions/create', locals: { result: result } }
    end
  end

  def delete_criterion
    result = Adm::Contest::ContestCriterionsService.new.delete_criterion params

    respond_to do |format|
      format.html
      format.js { render '', locals: { result: result } }
    end
  end
end
