module Learning
  module Batch
    class OpAttendanceSheet < ApplicationRecord
      self.table_name = 'op_attendance_sheet'

      belongs_to :op_session, foreign_key: 'session_id'

      has_many :op_attendance_lines, :foreign_key => 'attendance_id'
    end
  end
end