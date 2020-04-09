namespace :map_student_create_user do
  desc 'Create student users, parent users with op_student data'
  task :maping, [:student_id] => :environment do |t, arg|
    student_ids = arg[:student_id].to_i
    if student_ids == -1
      student_list = User::OpStudent.all.uniq
    else
      student_list = User::OpStudent.where(id: student_ids)
    end

    User::UsersController.new.map_student_new_user student_list
  end

  desc 'Create teacher account by faculty_id'
  task :create_faculty, [:faculty_id] => :environment do |t, arg|
    faculty_id = arg[:faculty_id].to_i
    if faculty_id
      faculty = User::OpFaculty.find(faculty_id)
      unless faculty.nil?
        User::UsersController.new.map_faculty_create_user faculty
      end
    end
  end

  desc 'Create all teacher accounts'
  task :create_mass_faculty_account, [] => :environment do |t,arg|
    faculty_list = User::OpFaculty.all.uniq
    faculty_list.each do |faculty|
      unless faculty.nil?
        puts faculty.id
        User::UsersController.new.map_faculty_create_user faculty
        puts 'done!'
      end
    end
  end
end
