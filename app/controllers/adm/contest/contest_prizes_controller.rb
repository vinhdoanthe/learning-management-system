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
      format.html
      format.js { render "adm/contest/contest_prizes/availabe_months", locals: contest }
    end
  end

  def contest_prize_detail
    prize = Contest::ContestPrize.where(id: params[:id]).first
    contest = Contest::Contest.where(id: params[:contest_id]).first
    prizes = contest.contest_prizes
    update = params[:update].present? ? false : true

    respond_to do |format|
      format.html
      format.js { render 'adm/contest/contest_prizes/contest_prize_detail', locals: { prize: prize, contest: contest, prizes: prizes, update: update }}
    end
  end
end
