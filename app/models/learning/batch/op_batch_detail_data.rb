module Learning
  module Batch
    class OpBatchDetailData
      def initialize(op_batch, op_student_courses)
        @op_batch = op_batch
        @op_student_courses = Array.new
        op_student_courses.each do |op_student_course|
          @op_student_courses.append op_student_course
        end
      end
    end
  end
end