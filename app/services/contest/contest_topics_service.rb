class Contest::ContestTopicsService
  def contest_month_topic contest_id
    contest = Contest::Contest.where(id: contest_id).first
    topics = contest.contest_topics
    last_month_topics = topics.where(start_time: month_time(Time.now - 1.month)).limit(4)
    next_month_topics = topics.where(start_time: month_time(Time.now + 1.month)).limit(4)
    current_month_topics = topics.where(start_time: Time.now).order(start_time: :ASC).limit(4)
    active_topic = topics.where(status: 'active').first
    active_topic = current_month_topics[-1] if active_topic.blank?

    active_topic_index = current_month_topics.find_index(active_topic)

    { last_month_topics: last_month_topics, next_month_topics: next_month_topics, current_month_topics: current_month_topics, active_topic: active_topic, active_topic_index: active_topic_index }
  end

  def month_time time
    time.beginning_of_month..time.end_of_month
  end
end
