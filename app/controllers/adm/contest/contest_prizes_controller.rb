class Adm::Contest::ContestPrizesController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:create_prize]

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
end
