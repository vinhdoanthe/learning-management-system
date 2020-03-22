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
end
