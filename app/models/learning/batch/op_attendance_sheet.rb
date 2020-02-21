module Learning
  module Batch
    class OpAttendanceSheet < ApplicationRecord
      self.table_name = 'op_attendance_sheet'

      has_many :op_attendance_lines, :foreign_key => 'attendance_id'
      belongs_to :op_attendance_register, :foreign_key => 'register_id'
    end
  end
end