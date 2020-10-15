class Adm::Contest::ContestTopicsService
  def create_topic params
    contest = Contest::Contest.where(id: params[:contest_ic]).first
    return { type: 'danger', message: 'Cuoc thi khong ton tai' } if contest.blank?

    attributes = ['name', 'contest_id', 'rule', 'region', 'start_time', 'end_time']
    can_create = true
    attributes.each{ |att| can_create = false if params[att].blank? }
    return { type: 'danger', message: 'Thieu thong tin cuoc thi' } unless can_create

    create_params = ['name', 'contest_id', 'rule', 'region', 'start_time', 'end_time', 'description', 'rule']
    topic = Contest::ContestTopic.new
    create_params.each{ |att| topic.send(att, params[att]) }

    if topic.save
      create_topic_prizes topic, params[:prize_ids]
      { type: 'success', message: 'Tao chu de thanh cong', topic: topic }
    else
      { type: 'danger', message: 'Da co loi xay ra! Vui long thu lai sau!' }
    end

  end

  def create_topic_prizes topic, prize_ids
    topic_id = topic.id
    prize_ids.each do |prize|
      t_prize = Contest::TopicPrize.new
      t_prize.contest_topic_id = topic_id
      t_prize.prize_ids = prize
      t_prize.save
    end
  end
end
