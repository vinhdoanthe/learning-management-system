namespace :user do

  desc 'Create User for Student'
  task :create_users_within_days, [:prev_days] => :environment do |t, args|
    puts "Start create users"
    prev_days = args[:prev_days].to_i
    if prev_days
      prev_seconds = prev_days*24*60*60
      create_date_offset = Time.now() - prev_seconds
      students = User::OpenEducat::OpStudent.where('create_date >= ?', create_date_offset).to_a
      User::Account::UsersController.new.map_student_new_user students
    end
    puts "End create users"
  end
end
