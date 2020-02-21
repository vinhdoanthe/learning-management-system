module Learning
  module Batch
    class OpSession < ApplicationRecord
      self.table_name = 'op_session'
      self.inheritance_column = 'object_type'

      belongs_to :op_faculty, :class_name => 'User::OpFaculty', foreign_key: 'faculty_id'
      belongs_to :op_batch, :class_name => 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
      belongs_to :op_subject, :class_name => 'Learning::Course::OpSubject', foreign_key: 'subject_id'
      belongs_to :op_lession, :class_name => 'Learning::Course::OpLession', foreign_key: 'lession_id', required: false

      has_many :op_session_students, :class_name => 'Learning::Batch::OpSessionStudent', foreign_key: 'session_id'
      has_many :op_attendance_lines, :class_name => 'Learning::Batch::OpAttendanceLine', foreign_key: 'session_id'
      has_many_attached :photos

      def start_time
        self.start_datetime
      end
    end
  end
end
