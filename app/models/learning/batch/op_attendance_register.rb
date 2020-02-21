module Learning
  module Batch
    class OpAttendanceRegister < ApplicationRecord
      self.table_name = 'op_attendance_register'

      has_many :op_attendance_sheet, foreign_key: 'register_id'
    end
  end
end