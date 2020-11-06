class Adm::Contest::ContestTopicsService

  def create_topic params
    contest = Contest::Contest.where(id: params[:contest_id]).first
    return { type: 'danger', message: 'Cuoc thi khong ton tai' } if contest.blank?

    attributes = ['name', 'contest_id', 'region', 'start_time', 'end_time']
    can_create = true
    attributes.each{ |att| can_create = false if params[att].blank? }
    return { type: 'danger', message: 'Thieu thong tin cuoc thi' } unless can_create

    create_params = ['name', 'contest_id', 'region', 'start_time', 'end_time', 'description', 'thumbnail']
    
    topic = Contest::ContestTopic.new
    create_params.each{ |att| topic.send(att + '=', params[att]) }

    if topic.save
      create_topic_prizes topic, params[:contest_prizes][0].split(',')
      create_topic_criterion topic, params[:contest_criterions][0].split(',')
      { result: { type: 'success', message: I18n.t("notice.add_new_success")}, topic: topic, contest: contest, action: 'create' }
    else
      { result: { type: 'danger', message: I18n.t("notice.update_fail") },action: 'create' }
    end

  end

  def update params
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    contest = topic.contest
    #contest = Contest::Contest.where(id: params[:contest_id]).first

    update_params = ['name', 'contest_id', 'region', 'start_time', 'end_time', 'description', 'thumbnail', 'status']

    if params[:status].present? && params[:status] == 'active'
      contest.contest_topics.update_all(status: 'inactive')
    end

    update_params.each do |att|
      topic.send(att + '=', params[att]) if params[att].present?
    end

    if topic.save
      { result: { type: 'success', message: I18n.t("notice.update_success")}, action: 'update', topic: topic, contest: contest }
    else
      { result: {type: 'danger', message: I18n.t("notice.update_fail")}, action: 'update', topic: topic}
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
    topic_id = topic.id
    criterion_ids.each do |c_id|
      t_criterion = Contest::ContestTopicCriterion.new
      t_criterion.contest_topic_id = topic_id
      t_criterion.contest_criterion_id = c_id
      t_criterion.save
    end
  end

  def calculate_criterions_point topic
    begin
    qry = " SELECT a.id, SUM(b.point_exchange) AS point_max
            FROM tk_contest_projects AS a
            LEFT JOIN tk_project_criterions AS b ON a.id = b.contest_project_id
            WHERE a.contest_topic_id = #{ topic.id }
            GROUP BY a.id
            ORDER BY point_max DESC "
    contest_exchanges = Contest::ContestExchange.where(status: 'active').pluck(:id, :top_from, :top_end, :point).sort_by{|e| e[2] }
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
      { type: 'success', message: 'tinh toan xong' }
    rescue
      { type: 'danger', message: 'da co loi xay ra! Vui long thu laij sau' }
    end
  end

  def awarded_project topic, type
    topic_prizes = topic.contest_prizes.where(prize_type: type).pluck(:id, :prize, :number_awards).sort{|p| p[1] }
    total_awards = 0
    topic_prizes.each{ |p| total_awards += p[2] }

    #sql = " SELECT  project.id, SUM(project.score * #{ SCORE_RATIO } + project.judges_score * #{ JUDGES_SCORE_RATIO }) as point
    #        FROM  tk_contest_projects AS project
    #        GROUP BY project.id
    #        ORDER BY point DESC
    #        LIMIT #{ total_awards }
    #        "
    #projects = ActiveRecord::Base.connection.execute(sql).values

    awarded_projects = Contest::ContestProject.
      select("tk_contest_projects.id, SUM(score * #{ Contest::Constant::ScoreRatio::SCORE_RATIO } + judges_score * #{ Contest::Constant::ScoreRatio::JUDGES_RATIO }) as point").
      group('id').
      order(point: 'desc').
      limit(total_awards).
      to_a

    topic_prizes = topic.contest_prizes.where(prize_type: type).
    #topic_prizes = Contest::ContestPrize.
      order(prize: 'asc').
      select('tk_topic_prizes.id, prize, number_awards').
      to_a

    topic_prizes.each do |prize|
      Contest::ContestProject.where(id: awarded_projects.map(&:id)).update_all(contest_prize_id: prize.id)
    end


    #topic_prizes.each do |p|
    #  project_ids = []
    #  projects[0..(p[2] - 1)]&.each{ |p| project_ids << p[0] }
    #  Contest::ContestProject.where(id: project_ids).update_all(contest_prize_id: p[0])
    #  projects = projects.drop(p[2])
    #end
  end
end
