module Learning
  module Batch
    class OpBatchService

      def self.get_teachers_name(batch_id)
        batch = Learning::Batch::OpBatch.find(batch_id)
        names = Array.new
        if batch.nil?
          nil
        else
          teachers = batch.op_faculties
          unless teachers.nil?
            teachers.each do |teacher|
              names.append teacher.full_name
            end

          end
        end
        names
      end
    end
  end
end