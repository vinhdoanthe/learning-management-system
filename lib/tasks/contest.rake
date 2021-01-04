namespace :contest do

  desc 'Update like share for contest projects'
  task :update_like_share, [] => :environment do |t, args|
    active_contests = Contest::Contest.where(is_publish: true, default: true).to_a
    active_contests.each do |active_contest|
      topics = active_contest.contest_topics
      active_topic = topics.where(status: 'active').first

      projects = active_topic.contest_projects.where(is_valid: true)

      Contest::ContestsService.new.update_fb_social_count projects
    end
  end

  desc 'Update active topic'
  task :update_active_topic, [] => :environment do |t, args|
    active_contests = Contest::Contest.where(is_publish: true).to_a

    active_contests.each do |active_contest|
      topics = active_contest.contest_topics
      current_topic = topics.where(status: 'active').first
      if current_topic.present?
        next_topic = topics.where("start_time > ?", current_topic.end_time).order(start_time: :ASC).first

        if next_topic.present?
        if current_topic.end_time < Time.now && next_topic.start_time <= Time.now
          current_topic.status = 'inactive'
          next_topic.status = 'active'
          ActiveRecord::Base.transaction do
            current_topic.save
            next_topic.save
          end
        end
        end
      end
    end
  end

  desc 'Update topic region(One times)'
  task :create_tk_contest_topic_prize, [] => :environment do |t, args|
    mn_prize = Contest::ContestPrize.where(id: 1).first
    mn_prize.update(region: 'MN', contest_id: 2)
    contest = Contest::Contest.where(is_publish: true, default: true).first
    topic_ids = contest.contest_topics.pluck(:id)

    topic_ids.each do |id|
      new = Contest::ContestTopicPrize.new
      new.contest_topic_id = id
      new.contest_prize_id = 1
      new.save
    end

    mb_prize = Contest::ContestPrize.where(id: 2).first
    mb_prize.update(region: 'MB', number_awards: 1)
  end
end
