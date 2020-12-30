# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, {:error => 'log/schedule_error.log', :standard => 'log/schedule_cron.log'}

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

every 30.minutes do 
  rake "mapping:mapping_lesson_to_done_session_and_assign_homework[100]"
end

every 1.hour do 
  rake "user:create_users_within_days[30]"
  rake "user:create_faculty_users_within_days[30]"
  rake "social_community:add_reactions_to_posts[15,15]"
  rake "contest:update_like_share"
end

every 3.hours do
  rake "contest:update_active_topic"
end
