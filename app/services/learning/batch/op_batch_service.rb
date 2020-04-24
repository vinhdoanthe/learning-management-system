module Learning
  module Batch
    class OpBatchService

      def self.get_batch_detail(batch_id, student_id)
        batch = Learning::Batch::OpBatch.where(id: batch_id).first
        if !batch.nil?
          course = batch.op_course
          course_name = course.nil? ? '' : course.name
          active_student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id).first
          op_student_courses = Learning::Batch::OpStudentCourse.where(batch_id: batch_id).to_a
          faculty_ids = Learning::Batch::OpSession.where('batch_id = ? AND state != ?', batch_id, Learning::Constant::Batch::Session::STATE_CANCEL).pluck(:faculty_id).uniq.compact
          faculty_names = User::OpenEducat::OpFaculty.where(id: faculty_ids).pluck(:full_name).uniq.compact
          batch_subjects = course.op_subjects.pluck(:id, :level).uniq.compact
          done_subjects = Learning::Batch::OpSession.where(batch_id: batch_id, state: Learning::Constant::Batch::Session::STATE_DONE).pluck(:subject_id).uniq.compact
          session_count = count_done_session(batch)
          company = Common::ResCompany.where(id: batch.company_id).first
          company_name = company.nil? ? '-' : company.name
          classroom_ids= batch.op_sessions.pluck(:classroom_id).uniq.compact
          if classroom_ids.blank?
            classroom_name = ''
          else
            classroom = Common::OpClassroom.where(id: classroom_ids[0]).first
            classroom_name = classroom.nil? ? '' : classroom.name
          end
          return batch, course_name, active_student_course, op_student_courses, faculty_names, batch_subjects, done_subjects, session_count, company_name, classroom_name
        else
          return nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
        end 
      end

      def self.get_student_batch_progress(batch_id, student_id)
        batch = Learning::Batch::OpBatch.where(id: batch_id).first
        op_student_course = Learning::Batch::OpStudentCourse.where(batch_id: batch_id, student_id: student_id).last
        subjects = op_student_course.op_subjects.pluck(:id, :level).compact
        subject_ids = subjects.map{|subject| subject[0]}
        all_sessions = get_sessions(batch_id, student_id, subject_ids)
        coming_soon_session = find_coming_soon_session(all_sessions)
        done_sessions = find_done_sessions(all_sessions)
        tobe_sessions = find_tobe_sessions(all_sessions)
        cancel_sessions = find_cancel_sessions(all_sessions)

=begin TODO: Matching lesson - session
        done_sessions = pair_session_lessons(done_sessions)
        tobe_sessions = match_tobe_session_lessons(tobe_sessions)
        cancel_sessions = pair_cancel_sessions(cancel_sessions)
=end
        return batch, op_student_course, subjects, coming_soon_session, done_sessions, tobe_sessions, cancel_sessions
      end

      def self.get_sessions(batch_id, student_id, subject_ids = [], interval = {})
        op_student_course = Learning::Batch::OpStudentCourse.where(batch_id: batch_id, student_id: student_id).last
        op_student_course_id = op_student_course.nil? ? nil : op_student_course.id

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
            session_student = Learning::Batch::OpSessionStudent.where(session_id: session.id, student_course_id: op_student_course_id).first
            sessions << session if !session_student.nil?
          end
        end
        sessions
      end

      def self.pair_session_lessons(sessions)
        paired_sessions = []
        sessions.each do |session|
          lesson = session.op_lession
          paired_sessions << {session: session, lesson: lesson}
        end
        paired_sessions
      end

      def self.match_tobe_session_lessons(sessions)

      end

      def self.find_coming_soon_session(sessions)
        time_now = Time.now()
        coming_soon_session = nil
        sessions.each do |session|
          next if session.start_datetime < time_now
          next if session.state == Learning::Constant::Batch::Session::STATE_CANCEL
          coming_soon_session = session
        end
        coming_soon_session
      end

      def self.find_tobe_sessions(sessions)
        time_now = Time.now()
        tobe_sessions = []
        sessions.each do |session|
          next if session.start_datetime < time_now
          next if session.state == Learning::Constant::Batch::Session::STATE_CANCEL
          tobe_sessions << session
        end
        tobe_sessions
      end

      def self.find_cancel_sessions(sessions)
        cancel_sessions = []
        sessions.each do |session|
          next if session.state != Learning::Constant::Batch::Session::STATE_CANCEL
          cancel_sessions << session
        end
        cancel_sessions
      end

      def self.find_done_sessions(sessions)
        done_sessions = []
        sessions.each do |session|
          next if session.state != Learning::Constant::Batch::Session::STATE_DONE
          done_sessions << session
        end
        done_sessions
      end 
      
      def self.get_teachers_name(batch_id)
        faculty_ids = Learning::Batch::OpSession.where(batch_id: batch_id).pluck(:faculty_id).uniq
        faculty_id = faculty_ids.compact.first
        faculty = User::OpenEducat::OpFaculty.where(id: faculty_id).first
        faculty.nil? ? '' : faculty.full_name
      end

      def self.count_done_session(batch)
        last_done_session = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE, batch_id: batch.id).order(start_datetime: :ASC).last
        if last_done_session.nil?
          ''
        else
          last_done_session.count
        end
      end

=begin Will be removed
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
=end
    end
  end
end
