class Contest::ContestProjectsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:sumit_contest_project]

  def index
    @contest = Contest::Contest.first
    @topic = Contest::ContestTopic.first
  end

  def show
    @c_project = Contest::ContestProject.where(id: params[:id]).first
    views = @c_project.views
    @c_project.update(views: views + 1)
    @project = @c_project.student_project
    @user = @c_project.user
    @student = @user.op_student
    @like = @c_project.contest_criterions.where(name: 'like').first&.number.to_i
    @share = @c_project.contest_criterions.where(name: 'share').first&.number.to_i
    @prize = @c_project.contest_prize
    relate_projects = Contest::ContestProject.where(user_id: @c_project.user_id).limit(20)
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

  def contest_projects
    @contest = Contest::Contest.where(id: params[:contest_id]).first
    @topics = @contest.contest_topics.order(created_at: :DESC).limit(5)
    @topic = @topics.first
    @projects = @topic.contest_projects.where.not(project_id: nil)
    @project_details = []

    @projects.each do |project|
      @project_details << { project.id => (Contest::ContestsService.new.contest_project_detail project) }
    end
  end

  def projects_content
    @projects = Contest::ContestsService.new.contest_projects params
    @project_details = []
    @projects.each{ |project| @project_details << (Contest::ContestsService.new.contest_project_detail project) }
  end

  def submit_contest_project
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    #contest = topic.contest
    result, project, student = SocialCommunity::ScStudentProjectsService.new.create_new_student_project params, current_user

    if result[:type] == 'success'
      result, c_project = Adm::Contest::ContestProjectsService.new.create_contest_project topic, project
    end

    student
    respond_to do |format|
      format.html
      format.js { render '/contest/contest_projects/response_submit_project', locals: { result: result, c_project: c_project}}
    end
  end

  def month_projects
    #contest = Contest::Contest.where(id: params[:contest_id]).first
    contest = Contest::Contest.first

    month_projects = contest.contest_projects.joins(:contest_prize).joins(user: { op_student: :res_company }).joins(:student_project).joins(:project_criterions).where(tk_contest_prizes: { prize_type:'m', prize: 1 }).select('distinct(tk_contest_projects.id)', :created_at, :user_id, 'op_student.full_name as student_name', 'sc_student_projects.name as project_name', :views, 'res_company.name as company_name', :project_id).limit(5)

    project_ids = month_projects.pluck(:project_id).uniq
    m_project_imgs = {}

    project_ids.each do |id|
      project = SocialCommunity::ScStudentProject.where(id: id).first
      return {} if project.blank?
      m_project_imgs.merge!( { project.id => project.image })
    end

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/month_prizes', locals: { month_projects: month_projects, m_project_imgs: m_project_imgs }}
    end
  end

  def week_projects
    #contest = Contest::Contest.where(id: params[:contest_id]).first
    contest = Contest::Contest.first
    current_week_projects, c_w_imgs = Contest::ContestsService.new.week_projects contest, 'current'
    last_week_projects, l_w_imgs  = Contest::ContestsService.new.week_projects contest, 'last_week'

    respond_to do |format|
      format.html
      format.js { render 'contest/contests/js/week_contests', locals: { current_week_projects: current_week_projects, last_week_projects: last_week_projects, c_w_imgs: c_w_imgs, l_w_imgs: l_w_imgs } }
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
