module Learning
  module Batch
    module OpSessionsHelper
      def attendance_line(session_id, student_id)
        Learning::Batch::OpAttendanceLine.where(session_id: session_id, student_id: student_id).last
      end

      def get_lesson_of_session op_session
        if op_session.lession_id.nil?
          att_sheet = op_session.op_attendance_sheets.last
          if att_sheet.nil?
            nil
          else
            Learning::Course::OpLession.where(id: att_sheet.lession_id).first
          end
        else
          op_session.op_lession
        end
      end 
    end
  end
end
