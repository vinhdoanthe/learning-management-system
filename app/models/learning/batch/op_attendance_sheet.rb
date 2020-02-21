module Learning
  module Batch
    class OpAttendanceSheet < ApplicationRecord
      self.table_name = 'op_attendance_sheet'

      has_many :op_attendance_lines, :foreign_key => 'attendance_id'
    end
  end
end