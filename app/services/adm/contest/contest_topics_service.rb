class Adm::Contest::ContestTopicsService

  def create_topic params
    can_create = validate_create_topic params
    return can_create unless can_create[:success]

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

    #update_params = ['name', 'contest_id', 'region', 'start_time', 'end_time', 'description', 'thumbnail', 'status']

    if params[:status].present? && params[:status] == 'active'
      contest.contest_topics.update_all(status: 'inactive')
    end

    #if topic.present?

      update_params = ['name', 'contest_id', 'region', 'start_time', 'end_time', 'description', 'thumbnail', 'status']
      update_params.each do |att|
        topic.send(att + '=', params[att]) if (params[att].present? && params[att] != topic.send(att))
      end

      #topic_update = topic.update(
      #    name: params[:name],
      #    region: params[:region],
      #    start_time: params[:start_time],
      #    end_time: params[:end_time],
      #    description: params[:description],
      #    thumbnail: params[:thumbnail]
      #)

      #contest = Contest::Contest.where(id: params[:contest_id]).first

      if topic.save
        { result: { type: 'success', message: I18n.t("notice.update_success")}, action: 'update', topic: topic, contest: contest }
      else
        { result: {type: 'danger', message: I18n.t("notice.update_fail")}, action: 'update', topic: topic}
      end    
    #end

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

  def calculate_criterions_point topic, region
    company_id = Object.const_get("Contest::Constant::Region::#{ region }")
    topic.contest_projects.joins(user: { op_student: :res_company }).where(res_company: { id: company_id }).update_all(score: 0)

    #begin
    #qry = " SELECT a.id, SUM(b.point_exchange) AS point_max
    #        FROM tk_contest_projects AS a
    #        LEFT JOIN tk_project_criterions AS b ON a.id = b.contest_project_id
    #        INNER JOIN sc_student_projects as project ON a.project_id = project.id
    #        INNER JOIN op_student as student ON project.student_id = student.id
    #        WHERE a.contest_topic_id = #{ topic.id }
    #        AND student.company_id IN (#{ company_id.join(',')})
    #        GROUP BY a.id
    #        ORDER BY point_max DESC "

    contest_exchanges = Contest::ContestExchange.where(status: 'active').pluck(:id, :top_from, :top_end, :point).sort_by{|e| e[2] }
    exchange_hash = {}
    contest_exchanges.each do |e|
      exchange_hash.merge!({e[0] => [(e[1] - 1)..(e[2] - 1), e[3]]})
    end

    limit = contest_exchanges[-1][2]

    #qry += " LIMIT #{ limit } "
    #prize_projects = ActiveRecord::Base.connection.execute(qry).values
    prize_projects = topic.contest_projects.
                      joins(:project_criterions).
                      joins(user: { op_student: :res_company}).
                      where(res_company: { id: company_id }).
                      select(:id,
                             'sum(tk_project_criterions.point_exchange) as max_point').
                      group(:id).
                      order('max_point DESC').
                      limit(limit)

    exchange_hash.each do |key, val|
      project_ids = []
      prize_projects[val[0]]&.each{ |p| project_ids << p.id }
      Contest::ContestProject.where(id: project_ids).update_all(score: val[1])
    end

    { type: 'success', message: 'tinh toan xong' }
  rescue
    { type: 'danger', message: 'da co loi xay ra! Vui long thu laij sau' }

  end

  def awarded_project topic, type, region
    validate = validate_week_award topic, region
    return validate if validate[:type] == 'danger'
    topic_prizes = topic.contest_prizes.where(prize_type: type, region: region).
                                        order(prize: 'asc').
                                        select('tk_contest_prizes.id, prize, number_awards').to_a

    total_awards = topic_prizes.sum(&:number_awards)

    awarded_projects = topic.contest_projects.  joins(student_project: { op_student: :res_company }).where(res_company: { id: Object.const_get("Contest::Constant::Region::" + region)}).  select("tk_contest_projects.id, score * #{ Contest::Constant::ScoreRatio::SCORE_RATIO } + judges_score * #{ Contest::Constant::ScoreRatio::JUDGES_RATIO } as point").  group('id').  order(point: 'desc').
      limit(total_awards).
      to_a

    topic_prizes.each do |prize|
      projects = awarded_projects.shift prize.number_awards
      Contest::ContestProject.where(id: projects.map(&:id)).update_all(contest_prize_id: prize.id)
    end
  end

  private

  def validate_create_topic params
    #check duplicate topic time
    start_time = Time.parse(params[:start_time])
    end_time = Time.parse(params[:end_time])

    exist_topic = Contest::ContestTopic.where(start_time: start_time..end_time).or(Contest::ContestTopic.where(end_time: start_time..end_time)).first
    return { result: { type: 'danger', message: 'Đã có cuộc thi diễn ra trong thời gian này! Vui lòng kiểm tra lại!'}, success: false } if exist_topic.present?

    #check duplicate prizes
    prizes = Contest::ContestPrize.where(id: params[:contest_prizes]).pluck(:id, :prize_type, :prize)
    prize_group = prizes.group_by{ |p| p[1] }

    valid_prize = true
    prize_group.each do |k, v|
      prize_type = v.group_by{ |p| p[2] }
      prize_type.each{ |k, v| valid_prize = false if v.length > 1 }
    end

    if valid_prize == false
      return { result: { type: 'danger', message: 'Chọn trùng giải thưởng! Vui lòng kiểm tra laị' }, success: false }
    end

    true
  end

  def validate_update_topic params
  end

  def validate_week_award topic, region
    return { type: 'danger', message: 'Chủ đề vẫn đang diễn ra! Chưa thể trao giải!' } if Time.now < topic.end_time

    if topic.contest_projects.where.not(contest_prize_id: nil).count >= 2
      return { type: 'danger', message: 'Chủ đề này đã trao giải thưởng! Không thể trao giải lại' }
    end

    if topic.contest_projects.joins(:contest_prize).where(tk_contest_prizes: { region: region }).present?
      return { type: 'danger', message: '' }
    end
    { type: 'success' }
  end
end
