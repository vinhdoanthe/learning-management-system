module Learning
  module Batch
    module OpSessionsHelper
      def attendance_line(session_id, student_id)
        Learning::Batch::OpAttendanceLine.where(session_id: session_id, student_id: student_id).last
      end        
    end
  end
end
