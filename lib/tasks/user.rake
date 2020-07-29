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

  desc 'Update initial_password for old user'
  task :update_initial_password, [:time] => :environment do |t, args|
    index = 1
    puts 'Start'
    count = User::Account::User.where(account_role: 'Student').count
    student_users = User::Account::User.where(account_role: 'Student').to_a
    student_users.each do |user|
      if user.authenticate('123456') ||  user.authenticate('TekyAcademy')
        password = (0..8).map { (65 + rand(26)).chr }.join
        user.initial_password = password
        user.password = password
        if user.save
          puts "done #{ index } / #{ count }"
        else
          puts "Error user_id: #{ user.id }"
        end
        index += 1
      end
    end
  end
  
  desc 'Create Operation Account'
  task :create_operation_accounts, [] => :environment do |t, args|
    companies = Common::ResCompany.all.to_a
    puts "Total #{companies.count}"
    companies.each_with_index do |company, index|
      next if company.code.nil?
      puts "Processing #{index + 1}"
      user = User::Account::User.new
      user.account_role = Constant::OPERATION_ADMIN
      user.email = company.email
      user.username = "vh#{company.code.downcase}"
      user.password = user.username
      if user.save
        puts "Company: #{company.name}"
        puts "Username: #{user.username}"
        user_company = Common::UserCompany.new
        user_company.user_id 
        user_company.company_id = company.id
        user_company.save
      end
    end 
  end
end
