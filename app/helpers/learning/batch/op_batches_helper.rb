module Learning
  module Batch
    module OpBatchesHelper
      def list_subject_level_of_student(op_student_course_id)
        op_student_course = Learning::Batch::OpStudentCourse.find(op_student_course_id)
        subjects = op_student_course.op_subjects
        levels = Array.new
        if subjects.nil?
          levels = nil
        else
          subjects.each do |subject|
            levels.append subject.level
          end
        end
        levels
      end

      def list_subject_level_of_batch(batch_id)
        op_batch = Learning::Batch::OpBatch.find(batch_id)
        subjects = op_batch.op_course.op_subjects
        levels = Array.new
        if subjects.nil?
          levels = nil
        else
          subjects.each do |subject|
            levels.append subject.level
          end
        end
        levels
      end
    end
  end
end