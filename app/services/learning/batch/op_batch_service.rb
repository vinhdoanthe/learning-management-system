module Learning
  module Batch
    class OpBatchService
      include HomeworkConstants

      def self.get_batch_detail(batch_id, student_id)
        batch = Learning::Batch::OpBatch.where(id: batch_id).first
        if !batch.nil?
          course = batch.op_course
          course_name = course.nil? ? '' : course.name
          active_student_course = Learning::Batch::OpStudentCourse.where(student_id: student_id, batch_id: batch_id).first
          op_student_courses = Learning::Batch::OpStudentCourse.where(batch_id: batch_id).to_a
          batch_subjects = course.op_subjects.order(level: :ASC).pluck(:id, :level).uniq.compact
          done_subjects = Learning::Batch::OpSession.where(batch_id: batch_id, state: Learning::Constant::Batch::Session::STATE_DONE).pluck(:subject_id).uniq.compact
          pinned_session = User::OpenEducat::OpStudentsService.get_comming_soon_session student_id
          if pinned_session.nil?
            pinned_session = last_done_session(student_id, [batch_id], done_subjects)
            pinned_session = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE, batch_id: batch.id).order(start_datetime: :ASC).last
          end
          if pinned_session.nil?
            faculty_names = []
            classroom_name = '' 
          else
            gen_batch_table_lines = batch.gen_batch_table_lines
            if !gen_batch_table_lines.empty?
              faculty_names = []
              classroom_names = []
              gen_batch_table_lines.each do |gen_batch_table_line|
                faculty = gen_batch_table_line.op_faculty
                if !faculty.nil?
                  faculty_names << faculty.full_name
                end

                classroom = gen_batch_table_line.op_classroom
                if !classroom.nil?
                  classroom_names << classroom.name
                end
              end
              classroom_name = classroom_names.join(', ') if !classroom_names.empty?
            else
              # Get faculty and classroom by pinned session
              faculty = pinned_session.op_faculty
              if !faculty.nil?
                faculty_names = [faculty.full_name]
              else
                faculty_names = []
              end

              classroom = pinned_session.op_classroom
              if !classroom.nil?
                classroom_name = classroom.name
              else
                classroom_name = ''
              end
            end
          end
          session_count = count_done_session(batch)
          company = Common::ResCompany.where(id: batch.company_id).first
          company_name = company.nil? ? '-' : company.name
          return batch, course_name, active_student_course, op_student_courses, faculty_names, batch_subjects, done_subjects, session_count, company_name, classroom_name
        else
          return nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
        end 
      end

      def self.get_student_batch_progress(batch_id, student_id)
        batch = Learning::Batch::OpBatch.where(id: batch_id).first
        op_student_course = Learning::Batch::OpStudentCourse.where(batch_id: batch_id, student_id: student_id).last
        subjects = op_student_course.op_subjects.order(level: :ASC).pluck(:id, :level).compact
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
        if current_index.nil?
          current_index = -1
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

        if subject_ids.blank?
          subject_ids = op_student_course.op_subjects.pluck(:id).uniq.compact
        end

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

        # Hot fix: học sinh đã kết thúc học hoặc bảo lưu
        if op_student_course.state != Learning::Constant::STUDENT_BATCH_STATUS_ON
          all_sessions = all_sessions.select {|session| session.state == Learning::Constant::Batch::Session::STATE_DONE or session.state == Learning::Constant::Batch::Session::STATE_CANCEL}
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
          break
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

      def self.last_done_session(student_id, batch_ids = [], subject_ids = [])
        att = Learning::Batch::OpAttendanceLine.joins(:op_session).where(student_id: student_id).where(op_session: { batch_id: batch_ids, subject_id: subject_ids }.select{|k,v| !v.blank?}).order(create_date: :DESC).first

        if att.present?
          active_session = att.op_session
        else
          active_session = Learning::Batch::OpSession.where(batch_id: batch_ids).order(start_datetime: :DESC).first
        end

        active_session
      end

      def self.get_student_homework_report batch_id, subject_id = nil , faculty_id = nil, student_ids = []
        student_homework_report = Learning::Homework::Report::StudentHomework.new
        if student_ids.blank? # get report for all students in batch
          # find sessions
          sessions = Learning::Batch::OpSessionsService.get_sessions(batch_id, subject_id, faculty_id)
          r_sessions = sessions.map {|op_session| Learning::Homework::Report::SessionWithLesson.new(op_session.id, op_session.lession_id, (op_session.op_lession.nil? ? nil : op_session.op_lession.lession_number))}
          student_homework_report.sessions = r_sessions

          session_ids = sessions.map{|session| session.id}
          op_student_ids = Learning::Batch::OpSessionStudent.where(session_id: session_ids).pluck(:student_id).uniq
          user_ids = User::Account::User.where(student_id: op_student_ids).pluck(:id).uniq
          lesson_ids = (sessions.map {|session| session.lession_id}).uniq.compact
          questions = Learning::Material::Question.where(op_lession_id: lesson_ids).compact
          question_ids = questions.map {|question| question.id}
          question_ids = Learning::Material::Question.where(op_lession_id: lesson_ids).pluck(:id).compact
          user_questions = Learning::Homework::UserQuestion.where(op_batch_id: batch_id, question_id: question_ids, student_id: user_ids).to_a
          user_question_ids = user_questions.map {|user_question| user_question.id}
          user_answers = Learning::Homework::UserAnswer.where(user_question_id: user_question_ids, state: [UserAnswer::ANSWER_RIGHT, UserAnswer::ANSWER_WAITING]).to_a
          # caculate the report          
          student_users = User::Account::User.includes(:op_student).where(id: user_ids).to_a
          # op_students = User::OpenEducat::OpStudent.where(id: op_student_ids).to_a
          r_data = []
          student_users.each do |student_user|
            r_data_row = Learning::Homework::Report::StudentHomeworkDataRow.new
            r_data_row.student_id = student_user.op_student.id
            r_data_row.student_name = student_user.op_student.full_name
            count_homework_state = []
            r_sessions.each do |r_session|
              # count done user_question
              # count total user_question
              lesson_id = r_session.lesson_id
              l_questions = questions.select {|question| question.op_lession_id == lesson_id}
              l_question_ids = l_questions.map {|question| question.id}
              l_user_questions = user_questions.select {|user_question| (l_question_ids.include?(user_question.question_id) and user_question.student_id == student_user.id) }
              count_total = l_user_questions.size
              l_user_question_ids = l_user_questions.map {|user_question| user_question.id}
              l_done_user_answers = user_answers.select {|user_answer| l_user_question_ids.include?(user_answer.user_question_id)}    
              count_done = l_done_user_answers.size
              count_homework_state << [count_done, count_total]
            end
            r_data_row.count_homework_state = count_homework_state
            r_data << r_data_row
          end
          student_homework_report.data = r_data
        else
        end 
        student_homework_report
      end
      # Get list batch by paramater
      def self.find_batch_by_params(params)
        company_id  =  params[:company_id]
        start_date  =  Date.parse(params[:start_date].to_s).strftime("%Y%m%d").to_i
        end_date    =  Date.parse(params[:end_date].to_s).strftime("%Y%m%d").to_i
        active      =  params[:active]
        state       =  params[:state]
        list = Learning::Batch::OpBatch.select("id, name")
        .where(:active => active)
        .where("TO_CHAR(start_date, 'YYYYMMDD') >='#{start_date}' AND TO_CHAR(end_date, 'YYYYMMDD') <='#{end_date}'")     
        return list
      end
    end
  end
end