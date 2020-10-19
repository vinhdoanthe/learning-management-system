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
      create_topic_prizes topic, params[:contest_prizes]
      create_topic_criterion topic, params[:contest_criterions]
      { type: 'success', message: 'Tao chu de thanh cong', topic: topic, contest: contest }
    else
      { type: 'danger', message: 'Da co loi xay ra! Vui long thu lai sau!' }
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
end
