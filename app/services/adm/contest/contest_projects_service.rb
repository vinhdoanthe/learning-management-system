class Adm::Contest::ContestProjectsService

  def index_content params
    if params[:contest].present?
      contest = Contest::Contest.where(id: paramz[:contest]).first
      topic = contest.contest_topics.where(status: 'active').first
    else
      topic = Contest::ContestTopic.where(status: 'active').first
      contest = topic.contest
    end

    c_projects = topic.contest_projects

    c_projects_detail = {}
    c_projects.each do |cp|
      c_projects_detail.merge! ({ cp.project_id => { score: cp.score, judges_score: cp.judges_score, view: cp.views, id: cp.id }})
    end

    project_ids = c_projects.pluck(:project_id)
    projects_detail = SocialCommunity::ScStudentProject.joins(:op_course).joins(op_student: :res_company).where(id: project_ids).select(:id, :name, "op_course.name as course_name", :student_id, "op_student.full_name as student_name", "res_company.name as company_name")
    
    [contest, topic, c_projects_detail, projects_detail]
  end

  def create_contest_project contest, project
    return { type: 'danger', message: 'Cuoc thi khong ton tai' } if contest.blank?
    #topic = contest.contest_topics.where(status: 'active').first
    topic = Contest::ContestTopic.first
    return { type: 'danger', message: 'Chu de cuoc thi k ton tai! Vui long lien he ban to chuc de biet them chi tiet' } if topic.blank?

    c_project = Contest::ContestProject.new
    c_project.project_id = project.id
    c_project.contest_topic_id = topic.id
    c_project.user_id = project.user_id
    #c_project.is_valid = check_valid? params
    c_project.is_valid = check_valid? contest
    c_project.contest_id = contest.id
    c_project.save
    create_project_criterion topic, c_project

    [{ type: 'success', message: 'dang bai du thi thanh cong'}, c_project ]
  end

  def update c_project, field, value
    c_project.send(field + "=", value)
    c_project.save
  end

  def create_project_criterion topic, c_project
    c_project_id = c_project.id
    criterion_ids = Contest::ContestTopicCriterion.where(contest_topic_id: topic.id).pluck(:contest_criterion_id)
    #criterion_ids << JUDGES_CRITERION_ID
    criterion_ids << 1

    criterion_ids.each do |c_id|
      p_criterion = Contest::ProjectCriterion.new
      p_criterion.contest_project_id = c_project_id
      p_criterion.contest_criterion_id = c_id
      p_criterion.save
    end
  end

  def project_point project
    project.score * SCORE_RATIO + project.judges_score * JUDGES_RATIO
  end

  def marking_contest_project c_project, point
    p_criterion = Contest::ProjectCriterion.where(contest_project_id: c_project.id, contest_criterion_id: JUDGES_CRITERION_ID).first
    p_criterion.update(number: point, point_exchange: point * JUDGES_RATIO)
  end

  private

  def check_valid? params
    true
  end
end
