class UpdateSessionAndAttendanceModel < ActiveRecord::Migration[6.0]
  def change
    # add columns to op_session table
    add_column :op_session, :operation_check_status, :string
    add_column :op_session, :operation_check_comment, :text

    # add columns to op_attendance_line table
    add_column :op_attendance_line, :attendance_state, :string
    add_column :op_attendance_line, :operation_comment, :text
  end
end
