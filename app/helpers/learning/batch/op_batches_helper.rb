module Learning
  module Batch
    module OpBatchesHelper
      def list_subject_level_of_student(op_student_course)
        # op_student_course = Learning::Batch::OpStudentCourse.find(op_student_course_id)
        subjects = op_student_course.op_subjects
        levels = Array.new
        if subjects.nil?
          levels = nil
        else
          subjects.each do |subject|
            levels.append subject.level
          end
        end
        levels
      end

      def get_list_subject_pairs(batch)
        subject_session_hash = {}

        unless batch.nil?
          sessions = batch.op_sessions

          unless sessions.nil?
            sessions.each do |session|
              subject = session.op_subject
              subject_session_hash.merge!({subject.id => subject.level})
            end
          end
        end

        subject_session_hash
      end

      def list_subject_level_of_batch(batch_id)
        op_batch = Learning::Batch::OpBatch.find(batch_id)
        sessions = op_batch.op_sessions
        levels = {}

        level = sessions.each do |session|
          subject = session.op_subject
          levels.merge!({subject.id => subject.level}) if subject.present?
        end

        levels
      end

      def teachers_name(batch_id)
        OpBatchService.get_teachers_name(batch_id)
      end

      def batch_active?(batch_id)
        batch = Learning::Batch::OpBatch.find(batch_id)
        student_courses = batch.op_student_courses
        is_active = false
        unless student_courses.nil?
          student_courses.each do |student_course|
            unless student_course.state == Learning::Constant::STUDENT_BATCH_STATUS_OFF
              is_active = true
            end
          end
        end
        is_active
      end

      def get_coming_soon_session(student_id:, batch_id:, checkpoint_datetime:)
        Learning::Batch::OpBatchService.get_coming_soon_session(student_id: student_id,
                                                                batch_id: batch_id,
                                                                checkpoint_datetime: checkpoint_datetime)
      end

      # def coming_session_student_batch(student_id:, batch_id:, checkpoint_datetime:)
      #   Learning::Batch::OpBatchService.coming_session_student_batch(student_id: student_id,
      #                                                                batch_id: batch_id,
      #                                                                checkpoint_datetime: checkpoint_datetime)
      # end

      def todo_session_student_batch(student_id:, batch_id:)
        Learning::Batch::OpBatchService.todo_session_student_batch(student_id: student_id, batch_id: batch_id)
      end

      def done_session_student_batch(student_id:, batch_id:)
        Learning::Batch::OpBatchService.done_session_student_batch(student_id: student_id, batch_id: batch_id)
      end

      def cancel_session_student_batch(student_id:, batch_id:)
        Learning::Batch::OpBatchService.cancel_session_student_batch(student_id: student_id, batch_id: batch_id)
      end

      def teacher_class_detail_active_session(session_id, subject_id, session_index, all_students)
        session[:active_session_id] = session_id
        session[:active_session_subject_id] = subject_id
        session[:active_session_index] = session_index
        session[:student_list] = all_students
      end

      def group_session_subjects(sessions)
        subject_groups = sessions.group_by {|session| session.subject_id}
        subject_session = subject_group.each {|k, v| subject_id[k] = v.pluck(:id)}
      end
      # def teacher_class_detail_current_session

      # end
    end
  end
end
