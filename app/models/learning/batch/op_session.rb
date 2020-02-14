module Learning
  module Batch
    class OpSession < ApplicationRecord
      self.table_name = 'op_session'
      self.inheritance_column = 'object_type'

      belongs_to :op_faculty, :class_name => 'User::OpFaculty', foreign_key: 'faculty_id'
      belongs_to :op_batch, :class_name => 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
      belongs_to :op_subject, :class_name => 'Learning::Course::OpSubject', foreign_key: 'subject_id'

      def start_time
        self.start_datetime
      end
    end
  end
end
