module Learning
  module Batch
    class OpBatchService

      def self.get_teachers_name(batch_id)
        faculty_ids = Learning::Batch::OpSession.where(batch_id: batch_id).pluck(:faculty_id).uniq
        faculty_id = faculty_ids.compact.first
        faculty = User::OpFaculty.find(faculty_id)
        faculty.nil? ? '' : faculty.full_name
      end

      def self.get_coming_soon_session(student_id:, batch_id:, checkpoint_datetime:)
        soonest_session = nil
        if checkpoint_datetime.nil?
          checkpoint_datetime = Time.now
        end
        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id, state: Learning::Constant::STUDENT_BATCH_STATUS_ON)
        op_student_courses.each do |op_student_course|
          op_subject_ids = op_student_course.op_subjects.map(&:id)
          session = Learning::Batch::OpSession.where("batch_id = ?  AND subject_id IN (?) AND start_datetime >= ?", op_student_course.batch_id, op_subject_ids, checkpoint_datetime).order(start_datetime: :DESC).first

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
              done_sessions.concat sessions
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
        errors = []
        done_sessions = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE)
        unless done_sessions.blank?
          done_sessions.each do |session|
            att_sheet = session.op_attendance_sheets.last
            unless att_sheet.nil?
              session.lession_id = att_sheet.lession_id
              session.save
              if session.errors.full_messages.any?
                errors << session.errors.full_messages.to_s
              end
            end
          end
        end
      end

    end
  end
end
