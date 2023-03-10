class Learning::Batch::OpSessionsService
  def self.is_present?(session_id, student_id)
    attendance_line = Learning::Batch::OpAttendanceLine.where(session_id: session_id, student_id: student_id).first
    return false if attendance_line.nil?
    return attendance_line.present
  end

  def self.report_attendance subject_id, student_id, sessions
    Learning::Batch::Report::SubjectStudentAttendanceReport.new(subject_id, student_id, sessions)
  end

  def self.get_sessions batch_id, subject_id, faculty_id
    Learning::Batch::OpSession.includes(:op_subject, :op_lession).where(batch_id: batch_id, subject_id: subject_id, faculty_id: faculty_id).order(:start_datetime => :ASC).to_a
  end

  def can_update_attendance_line? user, attendance
    if user.is_admin? || user.is_operation_admin?
      true
    elsif user.is_teacher?
      if (attendance.attendance_state != OpAttendanceLineConstant::State::STATE_COMPLETED && attendance.attendance_state != OpAttendanceLineConstant::State::STATE_PUBLISHED)
        true
      else
        false
      end
    else
      false
    end
  end
end
