module Learning
  module Batch
    class OpAttendanceSheet < ApplicationRecord
      self.table_name = 'op_attendance_sheet'

      belongs_to :op_session, foreign_key: 'session_id'
      belongs_to :op_lession, foreign_key: 'lession_id', class_name: 'Learning::Course::OpLession'
      has_many :op_attendance_lines, :foreign_key => 'attendance_id'
    end
  end
end
