class Contest::ContestsService
  def leader_board contest_id
    #student_name, topic, c_project_id, res_company => region, week???????????????/
    contest = Contest::Contest.where(id: contest_id).first
    week_projects = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'w', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).limit(8)

    month_project = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'm', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).first

    [week_projects, month_project, contest]

  end

  def week_projects contest, time_type
    time = if time_type == 'current'
             Time.now
           elsif time_type == 'last_week'
             Time.now - 1.week
           end

      w_projects =  contest.contest_projects
                    .joins(user: { op_student: :res_company })
                    .joins(:student_project)
                    .joins(:project_criterions)
                    .where(created_at: time.beginning_of_week..time.end_of_week)
                    .order(score: :DESC)
                    .select('distinct(tk_contest_projects.id)',
                            :created_at, :user_id,
                            'op_student.full_name as student_name',
                            'sc_student_projects.name as project_name',
                            :views,
                            :score,
                            'res_company.name as company_name',
                            :project_id)
                    .limit(6)

    project_ids = w_projects.pluck(:project_id)
    w_project_imgs = {}

    project_ids.each do |id|
      project = SocialCommunity::ScStudentProject.where(id: id).first
      return {} if project.blank?
      w_project_imgs.merge!( { project.id => project.image })
    end

    [ w_projects, w_project_imgs ]
  end

  def awarded_projects contest, type
    awarded_projects = contest.contest_projects
                        .joins(:contest_prize)
                        .where(tk_contest_prizes: { prize: '1', prize_type: type })

    details = {}
    awarded_projects.each do |project|
      details.merge! ({ project.id => ( contest_project_detail project )})
    end
    details
  end

  def contest_project_detail c_project
    project = c_project.student_project
    return {} if project.blank?
    like = c_project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'like' }).first&.number.to_i
    share = c_project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'share' }).first&.number.to_i
    user = c_project.user
    user_avatar = user.avatar&.thumbnail
    project_img = project.image
    
    details = c_project.as_json
    details.merge! ({ 'user_avatar' => user_avatar, 'project_name' => project.name, 'project_img' => project_img, 'created_at' => c_project.created_at, 'student_name' => project.op_student&.full_name, 'like' => like, 'share' => share, 'views' => c_project.views })

    details
  end
end
