class Contest::ContestProjectsController < ApplicationController

  def index
    @contest = Contest::Contest.first
    @topic = Contest::ContestTopic.first
  end

  def index_content
    contest = Adm::Contest::ContestProjectsService.new.index_content params
    contest
  end

  def submit_contest_project
    #contest = Contest::Contest.where(id: session[:contest])
    contest = Contest::Contest.last
    result, project, student = SocialCommunity::ScStudentProjectsService.new.create_new_student_project params, current_user
    if result[:type] == 'success'
      result, c_project = Adm::Contest::ContestProjectsService.new.create_contest_project contest, project
    end

    [result, project, student, c_project]
  end
end
