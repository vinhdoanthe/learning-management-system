namespace :contest do

  desc 'Update like share for contest projects'
  task :update_like_share, [] => :environment do |t, args|
    contests = Contest::Contest.where(is_publish: true)
    active_contest = [contests.where(default: true).first]
    topics = active_contest[0].contest_topics

    if topics.present?
      active_topic = topics.where(start_time: Time.now.beginning_of_week..Time.now.end_of_week).first

      if active_topic.present? && active_topic.present?
        topics.update_all(status: 'inactive')
        active_topic.update(status: 'active')
      end
    end

    active_contest.each do |contest|
      topic = contest.contest_topics.where(status: 'active').first
      projects = topic.contest_projects.where(is_valid: true)

      # projects= [Contest::ContestProject.last]
      Contest::ContestsService.new.update_fb_social_count projects
    end
  end
end
