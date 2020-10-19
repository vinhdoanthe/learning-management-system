class Adm::Contest::ContestProjectsService
  def create_contest_project params
    contest = Contest::Contest.where(id: params[:contest_id]).first
    return { type: 'danger', message: 'Cuoc thi khong ton tai' } if contest.blank?

    topic = contest.contest_topics.where(active: true).first
    return { type: 'danger', message: 'Chu de cuoc thi k ton tai! Vui long lien he ban to chuc de biet them chi tiet' } if topic.blank?

    c_project = Contest::ContestProject.new
    c_project.project_id = params[:project].id
    c_project.contest_topic_id = topic.id
    c_project.user_id = params[:project].user_id
    c_project.is_valid = check_valid? params
    c_project.contest_id = contest.id
    c_project.save
    create_project_criterion topic, c_project

    { type: 'success', message: 'dang bai du thi thanh cong', project: c_project }
  end

  def update c_project, field, value
    c_project.send(field + "=", value)
    c_project.save
  end

  def create_project_criterion topic, c_project
    c_project_id = c_project.id
    criterion_ids = Contest::ContestTopicCriterion.where(contest_topic_id: topic.id).pluck(:contest_criterion_id)
    criterion_ids << JUDGES_CRITERION_ID

    criterion_ids.each do |c_id|
      p_criterion = Contest::ProjectCriterion.new
      p_criterion.contest_project_id = c_project_id
      p_criterion.contest_criterion_id = c_id
      p_criterion.save
    end
  end

  def caculator_point c_project
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
