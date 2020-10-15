class Adm::Contest::ContestPrizesController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:create_prize]

  def new
  end

  def prepare_create
    result = Adm::Contest::ContestPrizesService.new.prepare_create params[:contest_id]

    respond_to do |format|
      format.html
      format.js { render "adm/contest/contest_prizes/create_form", locals: result }
    end
  end

  def create_prize
    result = Adm::Contest::ContestPrizesService.new.create params

    respond_to do |format|
      format.html
      format.js { render "adm/contest/contest_prizes/create", locals: result }
    end
  end

  def available_months
    contest = Contest::Contest.where(id: params[:contest_id]).first

    respond_to do |format|
      format.hmtl
      format.js { render "adm/contest/contest_prizes/availabe_months", locals: contest }
    end
  end
end
