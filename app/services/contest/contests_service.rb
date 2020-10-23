class Contest::ContestsService
  def leader_board contest_id
    #student_name, topic, c_project_id, res_company => region, week???????????????/
    contest = Contest::Contest.where(id: contest_id).first
    week_projects = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'w', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).limit(8)

    month_project = Contest::ContestProject.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'm', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).first

    [week_projects, month_project]

  end
end
