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
    contest = Contest::Contest.where(id: session[:contest]).first
    result, project, student = SocialCommunity::ScStudentProjectsService.new.create_new_student_project params, current_user
    if result[:type] == 'success'
      result, c_project = Adm::Contest::ContestProjectsService.new.create_contest_project contest, project
    end

    [result, project, student, c_project]
  end

  def month_project
    contest = Contest::Contest.where(id: params[:contest_id]).first
    month_projects = contest.contest_projects.joins(:contest_prize).joins(user: :op_student).joins(:student_project).joins(:project_criterions).where(contest_prize: { prize_type: 'm', prize: 1 }).select(:id, :created_at, 'op_student.full_name', 'student_project.name', :view).limit(5)

    month_projects

  end
end
