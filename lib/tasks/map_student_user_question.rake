namespace :map_student_user_question do
  desc 'Mapping User Question to Student'
  task :mapping, [:batch_id] => :environment do |t, arg|
    batch_id = arg[:batch_id]
    if batch_id == -1
      batches = Learning::Batch::OpBatch.all.uniq
    else
      batches = [Learning::Batch::OpBatch.where(id: batch_id).first]
    end

    batches.each_with_index do |batch, index|
      student_courses = batch.op_student_courses
      student_courses.each do |student_course|
        Learning::LearningRecordsController.new.maping_student_user_question student_course
        puts "#{index}/#{batches.count}"
      end
    end
  end
end
