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
        # Find last_done_lesson
        done_sessions = pair_session_lessons(done_sessions)
        done_lessons = done_sessions.map {|done_session| done_session[:lesson]}
        done_lessons = done_lessons.compact
        last_done_lesson = done_lessons.empty? ? nil : done_lessons[-1]
        # Find tobe_lessions
        all_lessons = Learning::Course::OpLession.where(subject_id: subject_ids).to_a.compact
        sorted_lessons = all_lessons.sort_by{|lesson| [lesson[:subject_id], lesson[:lession_number]]}
        tobe_lessons = []
        if last_done_lesson.nil?
          current_index = -1
        else
          current_index = sorted_lessons.index{|lesson| lesson[:id] == last_done_lesson.id}
        end
        start_index = current_index + 1
        end_index = sorted_lessons.size - 1
        for index in start_index..end_index
          tobe_lessons << sorted_lessons[index]
        end
        # Matching
        tobe_sessions = match_tobe_session_lessons(tobe_sessions, tobe_lessons)
        cancel_sessions = pair_session_lessons(cancel_sessions)
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
            if session.state == Learning::Constant::Batch::Session::STATE_DRAFT \
                or session.state == Learning::Constant::Batch::Session::STATE_CONFIRM \
                or session.state == Learning::Constant::Batch::Session::STATE_CANCEL
              # Not done session
              session_student = Learning::Batch::OpSessionStudent.where(session_id: session.id, student_course_id: op_student_course_id).first
              sessions << session if !session_student.nil?
            else
              # Done session
              att_line = Learning::Batch::OpAttendanceLine.where(session_id: session.id, student_id: student_id).first
              sessions << session if !att_line.nil?
            end
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

      def self.match_tobe_session_lessons(tobe_sessions, tobe_lessons)
        sessions = []
        s_size = tobe_sessions.size
        l_size = tobe_lessons.size
        if s_size > l_size
          for index in 0..(l_size-1)
            sessions << {session: tobe_sessions[index], lesson: tobe_lessons[index]}
          end
          for index in l_size..(s_size-1)
            sessions << {session: tobe_sessions[index], lesson: nil}
          end
        else
          for index in 0..(s_size-1)
            sessions << {session: tobe_sessions[index], lesson: tobe_lessons[index]}
          end
        end
        sessions
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

    end
  end
end
