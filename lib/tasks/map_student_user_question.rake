namespace :map_student_user_question do
  desc 'Mapping User Question to Student'
  task :mapping, [:batch_id] => :environment do |t, arg|
    batch_id = arg[:batch_id].to_i
    if batch_id == -1
      batch_ids = Learning::Batch::OpBatch.pluck(:id).uniq
    else
      batch_ids = Learning::Batch::OpBatch.where(id: batch_id).pluck(:id)
    end

    batch_ids.each_with_index do |batch, index|
      puts '-'*20
      student_course_ids = Learning::Batch::OpStudentCourse.where(batch_id: batch).pluck(:id)
      student_course_ids.each do |student_course_id|
        Learning::LearningRecordsController.new.maping_student_user_question student_course_id
        puts "OpStudentCourse id: #{student_course_id}"
      end
      puts "Batch: #{index+1}/#{batch_ids.count}"
    end
  end
end
