class Contest::ContestsService
  def leader_board contest_id
    #student_name, topic, c_project_id, res_company => region, week???????????????/
    contest = Contest::Contest.where(id: contest_id).first
    week_projects = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'w', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).limit(8)

    month_project = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'm', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).first

    [week_projects, month_project]

  end

  def week_projects contest, time_type
    time = if time_type == 'current'
             Time.now
           elsif time_type == 'last_week'
             Time.now - 1.week
           end
    contest.contest_projects.joins(user: { op_student: :res_company }).joins(:student_project).joins(:project_criterions).where(created_at: time.beginning_of_week..time.end_of_week).order(score: :DESC).select('distinct(tk_contest_projects.id)', :created_at, :user_id, 'op_student.full_name as student_name', 'sc_student_projects.name as project_name', :views, :score, 'res_company.name as company_name').limit(5)
  end
end
