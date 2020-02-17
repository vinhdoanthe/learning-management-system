module Learning
  module Batch
    class OpAttendanceLine < ApplicationRecord
      self.table_name = 'op_attendance_line'

      belongs_to :op_student, class_name: 'User::OpStudent', foreign_key: 'student_id'
      belongs_to :op_session, class_name: 'Learning::Batch::OpSession', foreign_key: 'session_id'
      
      def self.instance_method_already_implemented?(method_name)
        return true if method_name == 'present'
        return true if method_name == 'present?'
        super
      end
    end
  end
end