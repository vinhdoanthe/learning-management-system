class Adm::Contest::ContestTopicsController < Adm::AdmController
  def index
  end

  def new
  end

  def edit
  end

  def create_topic
    result = Adm::Contest::ContestTopicsService.new.create_topic params

    respond_to do |format|
      format.html
      format.js { render "adm/contest/contest_topics/create", locals: result }
    end
  end
end
