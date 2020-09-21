class AddEvaluateCompletedTimeToOpAttendanceLine < ActiveRecord::Migration[6.0]
  def change
    add_column :op_attendance_line, :evaluate_completed_time, :datetime
  end
end
