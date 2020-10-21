class Adm::Contest::ContestTopicsService
  def create_topic params
    contest = Contest::Contest.where(id: params[:contest_id]).first
    return { type: 'danger', message: 'Cuoc thi khong ton tai' } if contest.blank?

    attributes = ['name', 'contest_id', 'rule', 'region', 'start_time', 'end_time']
    can_create = true
    attributes.each{ |att| can_create = false if params[att].blank? }
    return { type: 'danger', message: 'Thieu thong tin cuoc thi' } unless can_create

    create_params = ['name', 'contest_id', 'rule', 'region', 'start_time', 'end_time', 'description', 'rule', 'thumbnail']
    topic = Contest::ContestTopic.new
    create_params.each{ |att| topic.send(att + '=', params[att]) }

    if topic.save
      create_topic_prizes topic, params[:contest_prizes][0].split(',')
      binding.pry
      create_topic_criterion topic, params[:contest_criterions][0].split(',')
      { result: { type: 'success', message: 'Tao chu de thanh cong'}, topic: topic, contest: contest }
    else
      { result: { type: 'danger', message: 'Da co loi xay ra! Vui long thu lai sau!' } }
    end

  end

  def clone_topic topic_id
    topic = Contest::ContestTopic.where(id: topic_id).first
    new_topic = Contest::ContestTopic.new(topic.attributes.except("id"))
    new_topic.save
  end

  def create_topic_prizes topic, prize_ids
    topic_id = topic.id
    prize_ids.each do |prize|
      t_prize = Contest::ContestTopicPrize.new
      t_prize.contest_topic_id = topic_id
      t_prize.contest_prize_id = prize
      t_prize.save
    end
  end

  def create_topic_criterion topic, criterion_ids
    binding.pry
    topic_id = topic.id
    criterion_ids.each do |c_id|
      t_criterion = Contest::ContestTopicCriterion.new
      t_criterion.contest_topic_id = topic_id
      t_criterion.contest_criterion_id = c_id
      t_criterion.save
    end
  end

  def caculator_projects_point topic
    qry = " SELECT a.id, SUM(b.point_exchange) AS point_max
            FROM tk_contest_projects AS a
            LEFT JOIN tk_project_criterions AS b ON a.id = b.contest_project_id
            WHERE a.contest_topic_id = #{ topic.id }
            GROUP BY a.id
            ORDER BY point_max DESC "
    #contest_exchanges = Contest::ContestExchange.where(status: 'active').pluck(:id, :top_from, :top_end, :point).sort_by{|e| e[2] }
    contest_exchanges = Contest::ContestExchange.pluck(:id, :top_from, :top_end, :point).sort_by{|e| e[2] }
    exchange_hash = {}
    contest_exchanges.each do |e|
      exchange_hash.merge!({e[0] => [(e[1] - 1)..(e[2] - 1), e[3]]})
    end

    limit = contest_exchanges[-1][2]

    qry += " LIMIT #{ limit } "
    prize_projects = ActiveRecord::Base.connection.execute(qry).values

    exchange_hash.each do |key, val|
      project_ids = []
      prize_projects[val[0]]&.each{ |p| project_ids << p[0] }
      Contest::ContestProject.where(id: project_ids).update_all(score: val[1])
    end
  end

  def awarded_project topic, type
    binding.pry
    topic_prizes = topic.contest_prizes.where(prize_type: type).pluck(:id, :prize, :number_awards).sort{|p| p[1] }
    total_awards = 0
    topic_prizes.each{ |p| total_awards += p[2] }

    sql = " SELECT  project.id, SUM(project.score * #{ SCORE_RATIO } + project.judges_score * #{ JUDGES_SCORE_RATIO }) as point
            FROM  tk_contest_projects AS project
            GROUP BY project.id
            ORDER BY point DESC
            LIMIT #{ total_awards }
            "
    projects = ActiveRecord::Base.connection.execute(sql).values

    topic_prizes.each do |p|
      project_ids = []
      projects[0..(p[2] - 1)]&.each{ |p| project_ids << p[0] }
      Contest::ContestProject.where(id: project_ids).update_all(contest_prize_id: p[0])
      projects = projects.drop(p[2])
    end
  end
end
