class Adm::Contest::ContestProjectsController < Adm::AdmController

  def index
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
end
