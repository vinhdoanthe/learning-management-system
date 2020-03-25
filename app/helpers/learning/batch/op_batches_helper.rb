module Learning
  module Batch
    module OpBatchesHelper

      def done_subject_ids(batch)
        OpSession.where(batch_id: batch.id,
                        state: Learning::Constant::Batch::Session::STATE_DONE).pluck(:subject_id).uniq.compact
      end

      def subject_ids(user, batch)
        subject_ids = []

        if user.nil? or batch.nil?
          return []
        end

        if user.is_student?
          op_student = user.op_student
          student_id = op_student.nil? ? nil : op_student.id

          unless student_id.nil?
            student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch.id).last
          end

          subject_ids = student_course.op_subjects.pluck(:id).uniq
        end

        subject_ids
      end

      def list_subject_level_of_student(op_student_course)
        subjects = op_student_course.op_subjects
        levels = []
        unless subjects.nil?
          subjects.each do |subject|
            levels.append [subject.id, subject.level]
          end
        end
        levels
      end

      def get_op_student_course(user,batch)

        if user.nil? or batch.nil?
          return nil
        end

        if user.is_student?
          op_student = user.op_student
          student_id = op_student.nil? ? nil : op_student.id

          unless student_id.nil?
            student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch.id).last
          end

        end

        student_course
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
        levels = []
        op_batch = Learning::Batch::OpBatch.find(batch_id)
        unless op_batch.nil?
          op_course = op_batch.op_course
          unless op_course.nil?
            levels =  Learning::Course::OpSubject.where(course_id: op_course.id).order(:level => :asc).pluck(:id, :level).uniq
          end
        end

        levels
      end
      
      def list_teacher_subject_level batch_id
        levels = []
        op_batch = Learning::Batch::OpBatch.find(batch_id)

        unless op_batch.nil?
          subject_ids = op_batch.op_sessions.pluck(:subject_id).uniq
          levels = Learning::Course::OpSubject.where(id: subject_ids).pluck(:id, :level).uniq
        end

        levels
      end

      def learning_room(batch_id)
        room_ids = Learning::Batch::OpSession.where(batch_id: batch_id).pluck(:classroom_id).uniq
        room_id = room_ids.compact.first
        classroom = room_id.nil? ? nil : Common::OpClassroom.find(room_id)
        classroom.nil? ? '' : classroom.name
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
        subject_id = {}
        subject_groups = sessions.group_by {|session| session.subject_id}
        subject_groups.each {|k, v| subject_id[k] = v.pluck(:id)}
        subject_id
      end

      def batch_timeline batch
        sessions_time = batch.op_sessions.where('start_datetime >= ? AND start_datetime <= ?', Time.now.beginning_of_week, Time.now.end_of_week).pluck(:start_datetime)
        if sessions_time.blank?
          session = batch.op_sessions.where('start_datetime >= ?', Time.now).first
          session = batch.op_sessions.order(start_datetime: :DESC).first if session.blank?	
          sessions_time = [session.start_datetime]
        end

        sessions_time
      end
    end
  end
end
