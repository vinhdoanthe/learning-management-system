module Learning
  module Batch
    class OpBatchService

      def self.get_teachers_name(batch_id)
        batch = Learning::Batch::OpBatch.find(batch_id)
        names = Array.new
        if batch.nil?
          nil
        else
          teachers = batch.op_faculties
          unless teachers.nil?
            teachers.each do |teacher|
              names.append teacher.full_name
            end

          end
        end
        names
      end

      def self.get_coming_session_student(student_id:, checkpoint_datetime:)
        soonest_session = nil
        if checkpoint_datetime.nil?
          checkpoint_datetime = Time.now
        end
        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id, state: Learning::Constant::STUDENT_BATCH_STATUS_ON)
        op_student_courses.each do |op_student_course|
          session = Learning::Batch::OpSession.where('batch_id = ? AND start_datetime >= ?', op_student_course.batch_id, checkpoint_datetime).order(start_datetime: :DESC).first
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

      def self.coming_session_student_batch(student_id:, batch_id:, checkpoint_datetime:)
        soonest_session = nil
        if checkpoint_datetime.nil?
          checkpoint_datetime = Time.now
        end
        op_student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, state: Learning::Constant::STUDENT_BATCH_STATUS_ON, batch_id: batch_id).fist
        unless op_student_course.nil?
          session = Learning::Batch::OpSession.where('batch_id = ? AND start_datetime >= ?', op_student_course.batch_id, checkpoint_datetime).first
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

      def self.done_session_student_batch(student_id:, batch_id:)
        # TODO: need updating find sessions by student_id
        done_sessions = nil

        sessions = Learning::Batch::OpSession.where(batch_id: batch_id,
                                                    state: Learning::Constant::Batch::Session::STATE_DONE)
                       .order(start_datetime: 'ASC').to_a
        unless sessions.nil?
          done_sessions = sessions
        end
        done_sessions
      end

      def self.todo_session_student_batch(student_id:, batch_id:)
        # TODO: need updating find sessions by student_id

        todo_sessions = nil
        sessions = Learning::Batch::OpSession.where('batch_id = ? AND (state ilike ? OR state ilike ?)',
                                                    batch_id,
                                                    Learning::Constant::Batch::Session::STATE_CONFIRM,
                                                    Learning::Constant::Batch::Session::STATE_DRAFT)
                       .order(start_datetime: 'ASC').to_a
        unless sessions.nil?
          todo_sessions = sessions
        end
        todo_sessions
      end

      def self.cancel_session_student_batch(student_id:, batch_id:)
        # TODO: need updating find sessions by student_id

        cancel_sessions = nil
        sessions = Learning::Batch::OpSession.where('batch_id = ? AND state ilike ?',
                                                    batch_id,
                                                    Learning::Constant::Batch::Session::STATE_CANCEL)
                       .order(start_datetime: 'ASC').to_a
        unless sessions.nil?
          cancel_sessions = sessions
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