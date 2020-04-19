module Learning
  module Batch
    class OpBatchService

      def self.get_teachers_name(batch_id)
        faculty_ids = Learning::Batch::OpSession.where(batch_id: batch_id).pluck(:faculty_id).uniq
        faculty_id = faculty_ids.compact.first
        faculty = User::OpFaculty.where(id: faculty_id).first
        faculty.nil? ? '' : faculty.full_name
      end

      def self.get_done_subject_count(batch)
        last_done_session = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE, batch_id: batch.id).order(start_datetime: :ASC).last
        if last_done_session.nil?
          ''
        else
          last_done_session.count
        end
      end

      def self.get_sessions(batch_id, student_id, subject_ids = [], interval = {})
        all_sessions = []
        if interval[:start].present? and interval[:end].present? 
          unless subject_ids.blank?
            all_sessions = Learning::Batch::OpSession.where(batch_id: batch_id, subject_id: subject_ids, start_datetime: interval[:start]..interval[:end]).order(start_datetime: :ASC).to_a
          end
        else 
          unless subject_ids.blank?
            all_sessions = Learning::Batch::OpSession.where(batch_id: batch_id, subject_id: subject_ids).order(start_datetime: :ASC).to_a
          end
        end
        sessions = []
        all_sessions.each do |session|
          if !session.is_offset
            if session.state == Learning::Constant::Batch::Session::STATE_DRAFT \
                or session.state == Learning::Constant::Batch::Session::STATE_CONFIRM \
                or session.state == Learning::Constant::Batch::Session::STATE_CANCEL
              # Not done session
              sessions << session
            else
              # Done session
              att_line = Learning::Batch::OpAttendanceLine.where(session_id: session.id, student_id: student_id).first
              sessions << session if !att_line.nil?
            end
          else
            session_student = Learning::Batch::OpSessionStudent.where(session_id: session.id, student_id: student_id).first
            sessions << session if !session_student.nil?
          end
        end
        sessions
      end

      def self.get_sessions_without_cancel(batch_id, student_id, subject_ids = [], interval = {})
        all_sessions = []
        if interval[:start].present? and interval[:end].present? 
          unless subject_ids.blank?
            all_sessions = Learning::Batch::OpSession.where(batch_id: batch_id, subject_id: subject_ids, start_datetime: interval[:start]..interval[:end]).order(start_datetime: :ASC).to_a
          end
        else 
          unless subject_ids.blank?
            all_sessions = Learning::Batch::OpSession.where(batch_id: batch_id, subject_id: subject_ids).order(start_datetime: :ASC).to_a
          end
        end
        sessions = []
        all_sessions.each do |session|
          next if session.state == Learning::Constant::Batch::Session::STATE_CANCEL
          if !session.is_offset
            if session.state == Learning::Constant::Batch::Session::STATE_DRAFT \
                or session.state == Learning::Constant::Batch::Session::STATE_CONFIRM
              # Not done session
              sessions << session
            else
              # Done session
              att_line = Learning::Batch::OpAttendanceLine.where(session_id: session.id, student_id: student_id).first
              sessions << session if !att_line.nil?
            end
          else
            session_student = Learning::Batch::OpSessionStudent.where(session_id: session.id, student_id: student_id).first
            sessions << session if !session_student.nil?
          end
        end
        sessions
      end

      def self.get_coming_soon_session(student_id:, batch_id:, checkpoint_datetime:)
        soonest_session = nil
        if checkpoint_datetime.nil?
          checkpoint_datetime = Time.now
        end
        op_student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id, state: Learning::Constant::STUDENT_BATCH_STATUS_ON).last
        unless op_student_course.nil?
          op_subject_ids = op_student_course.op_subjects.map(&:id)
          session = Learning::Batch::OpSession.where("batch_id = ?  AND subject_id IN (?) AND start_datetime >= ?", op_student_course.batch_id, op_subject_ids, checkpoint_datetime).order(start_datetime: :ASC).first

          unless session.nil?
            if soonest_session.nil?
              soonest_session = session
            else
              if soonest_session.start_datetime > session.start_datetime
                soonest_session = session
              end
            end
          end
        end
        soonest_session
      end

      def self.todo_session_student_batch(student_id:, batch_id:)
        todo_sessions = []
        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id)
        op_student_courses.each do |op_student_course|
          op_subject_ids = op_student_course.op_subjects.map(&:id)
          sessions = Learning::Batch::OpSession.where('batch_id = ? AND subject_id IN (?) AND (state ilike ? OR state ilike ?)',
                                                      batch_id,
                                                      op_subject_ids,
                                                      Learning::Constant::Batch::Session::STATE_CONFIRM,
                                                      Learning::Constant::Batch::Session::STATE_DRAFT)
            .order(start_datetime: 'ASC').to_a
          unless sessions.nil?
            todo_sessions.concat sessions
          end
        end

        todo_sessions
      end

      def self.done_session_student_batch(student_id:, batch_id:)
        done_sessions = []
        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id)
        op_student_courses.each do |op_student_course|
          op_subject_ids = op_student_course.op_subjects.map(&:id)
          unless op_subject_ids.nil?
            sessions = Learning::Batch::OpSession.where(batch_id: batch_id,
                                                        subject_id: op_subject_ids,
                                                        state: Learning::Constant::Batch::Session::STATE_DONE)
              .order(start_datetime: 'ASC').to_a
            unless sessions.nil?
              sessions.each do |session|
                att_line = Learning::Batch::OpAttendanceLine.where(session_id: session.id, student_id: student_id).first
                if !att_line.blank?
                  done_sessions << session
                end
              end
              # done_sessions.concat sessions
            end
          end
        end

        done_sessions
      end

      def self.cancel_session_student_batch(student_id:, batch_id:)
        cancel_sessions = []

        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id)
        op_student_courses.each do |op_student_course|
          op_subject_ids = op_student_course.op_subjects.map(&:id)

          sessions = Learning::Batch::OpSession.where('batch_id = ? AND subject_id IN (?) AND state ilike ?',
                                                      batch_id,
                                                      op_subject_ids,
                                                      Learning::Constant::Batch::Session::STATE_CANCEL)
            .order(start_datetime: 'ASC').to_a
          unless sessions.nil?
            cancel_sessions.concat sessions
          end
        end

        cancel_sessions
      end


      def self.match_session_with_lesson
        done_sessions = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE)
        total_count = done_sessions.length()
        count = 0
        unless done_sessions.blank?
          done_sessions.each do |session|
            count += 1
            if (count%100 == 0)
              puts "#{count}/#{total_count}"
            end
            att_sheet = session.op_attendance_sheets.pluck(:lession_id)
            unless att_sheet.blank?
              session.lession_id = att_sheet[-1]
              session.save
            end
          end
        end
      end

    end
  end
end
