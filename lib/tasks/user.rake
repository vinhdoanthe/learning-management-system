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

  desc 'Create User for Faculty'
  task :create_faculty_users_within_days, [:prev_days] => :environment do |t, args|
    puts 'Start create faculty users'
    prev_days = args[:prev_days].to_i
    if prev_days
      prev_seconds = prev_days*24*60*60
      create_date_offset = Time.now() - prev_seconds
      faculty_list = User::OpenEducat::OpFaculty.where('create_date >= ?', create_date_offset).to_a
      count_total = faculty_list.size
      faculty_list.each_with_index do |faculty, index|
        unless faculty.nil?
          puts "#{index}/#{count_total}"
          User::Account::UsersService.create_faculty_user faculty
          puts 'done!'
        end
      end
    end
    puts 'End create faculty users'
  end
end
