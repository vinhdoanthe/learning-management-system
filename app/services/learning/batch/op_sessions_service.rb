class Learning::Batch::OpSessionsService
  def self.is_present?(session_id, student_id)
    attendance_line = Learning::Batch::OpAttendanceLine.where(session_id: session_id, student_id: student_id).first
    return false if attendance_line.nil?
    return attendance_line.present
  end

  def self.report_attendance sessions, student_id
    return {} if sessions.empty?
    report_obj = {
      :tobe => 0,
      :cancelled => 0,
      :present_yes => 0,
      :present_no => 0
    }
    sessions.each do |session|
      if session.tobe?
        report_obj[:tobe] += 1
      elsif session.cancelled?
        report_obj[:cancelled] += 1
      elsif session.done?
        if is_present?(session.id, student_id)
          report_obj[:present_yes] += 1
        else
          report_obj[:present_no] += 1
        end
      end
    end
    report_obj
  end

  def self.get_sessions batch_id, subject_id, faculty_id
    Learning::Batch::OpSession.includes(:op_subject, :op_lession).where(batch_id: batch_id, subject_id: subject_id, faculty_id: faculty_id).to_a
  end
end
