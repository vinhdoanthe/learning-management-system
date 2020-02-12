module Learning
  module Batch
    class OpBatchService
      def self.batch_detail(batch_id)
        batch = OpBatch.find(batch_id)
        op_student_courses = batch.op_student_courses
        @op_batch_detail_data = Learning::Batch::OpBatchDetailData.new(batch, op_student_courses)
      end
    end
  end
end