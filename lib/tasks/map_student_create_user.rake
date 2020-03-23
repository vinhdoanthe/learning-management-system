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

  task :create_faculty, [:faculty_id] => :environment do |t, arg|
    faculty_ids = arg[:faculty_id]
    
    if faculty_ids == -1
      faculty_list = User::OpFaculty.all.uniq
    else
      faculty_list = User::OpFaculty.where(id: faculty_ids)
    end
    binding.pry 
    faculty_list.each do |faculty|
      User::UsersController.new.map_faculty_create_user faculty
    end
  end
end
