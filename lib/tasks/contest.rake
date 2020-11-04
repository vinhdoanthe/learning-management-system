namespace :contest do

  desc 'Update like share for contest projects'
  task :update_like_share, [] => :environment do |t, args|
    contests = Contest::Contest.where(is_publish: true)

    contests.each do |contest|
      #topic = contest.contest_topic.where(active: true).first
      #projects = topic.contest_projects.where(is_valid: true)

      projects= [Contest::ContestProject.last]
      Contest::ContestsService.new.update_fb_social_count projects
    end
  end
end
