class Contest::ContestProjectsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:sumit_contest_project]

  def index
    @contest = Contest::Contest.first
    @topic = Contest::ContestTopic.first
  end

  def show
    @c_project = Contest::ContestProject.where(id: params[:id]).first
    #@c_project = Contest::ContestProject.last
    @project = @c_project.student_project
    @user = @c_project.user
    @student = @user.op_student
    @like = @c_project.contest_criterions.where(name: 'like').first&.number.to_i
    @share = @c_project.contest_criterions.where(name: 'share').first&.number.to_i
    @prize = @c_project.contest_prize
    relate_projects = Contest::ContestProject.where(user_id: @c_project.user_id).limit(2)
    @relate_projects = []

    relate_projects.each do |p|
      name = p.student_project&.name
      @relate_projects << { project: p, project_name: name }
    end
    other_projects = Contest::ContestProject.where.not(user_id: @c_project.user_id).limit(3)
    @other_projects = []

    other_projects.each do |p|
      name = p.student_project&.name
      @other_projects << { project: p, project_name: name }
    end
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

  def month_projects
    #contest = Contest::Contest.where(id: params[:contest_id]).first
    contest = Contest::Contest.first

    month_projects = contest.contest_projects.joins(:contest_prize).joins(user: { op_student: :res_company }).joins(:student_project).joins(:project_criterions).where(tk_contest_prizes: { prize_type:'m', prize: 1 }).select('distinct(tk_contest_projects.id)', :created_at, :user_id, 'op_student.full_name as student_name', 'sc_student_projects.name as project_name', :views, 'res_company.name as company_name').limit(5)

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/month_prizes', locals: { month_projects: month_projects }}
    end
  end

  def week_projects
    #contest = Contest::Contest.where(id: params[:contest_id]).first
    contest = Contest::Contest.first
    current_week_projects = Contest::ContestsService.new.week_projects contest, 'current'
    last_week_projects = Contest::ContestsService.new.week_projects contest, 'last_week'

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/week_contests', locals: { current_week_projects: current_week_projects, last_week_projects: last_week_projects } }
    end
  end

  def project_detail
    c_project = Contest::ContestProject.where(id: params[:id]).first
    project = c_project.student_project
    batch = project.op_batch
    course = project.op_course
    student = project.op_student
    company_name = student.res_company&.name

    respond_to do |format|
      format.html
      format.js { render 'adm/contest/contest_projects/project_details', locals: { batch: batch, course: course, student: student, project: project, c_project: c_project, company_name: company_name}}
    end
  end

  def marking_project
    result = Contest::ContestProjectsService.new.marking_project params

    render json: result
  end
end
