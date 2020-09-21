class User::OpenEducat::OpTeachersService

  def self.filter_batch(teacher, batches, params)
    @batches = batches
    return [] if @batches.blank?

    query = ''

    if params[:active] && params[:active] != 'all'
      if params[:active] == 'true'
        query += "active = true AND "
      else
        query += "active = false AND "
      end
    end

    query += "op_batch.company_id = #{params[:company]} AND " unless params[:company].blank? || params[:company] == 'all'
    query = query[0..-5]
    total_class = @batches.where(query)

    if params[:start_date].present?
      @class = total_class.where.not('start_date >= ? OR end_date <= ?', params[:end_date].to_time.utc.strftime('%Y-%m-%d'), params[:start_date].to_time.utc.strftime('%Y-%m-%d'))
    else
      query = "start_date >= '#{(Time.now - 1000.days).to_time.utc.strftime('%Y-%m-%d')}'"
      @class = total_class.where(query)
    end
    @class.uniq
  end

  def teacher_class_detail batch, session
    students = {}
    all_students = {}

    student_courses = batch.op_student_courses

    student_courses.each do |sst|
      student = sst.op_student
      attendance = Learning::Batch::OpAttendanceLine.where(student_id: student.id, session_id: session.id).order(create_date: :DESC).first
      if attendance.present?
        attendance_state =  attendance.present
        state = attendance.attendance_state
      else
        attendance_state = ''
        state = ''
      end

      count_homework = count_student_homework student, session
      student_avatar = get_student_avatar student
      student_info = {student.id => {:note => '', :status => sst.state, :attendance => attendance_state, :code => student.code || '', :name => student.full_name || '', :avatar_src => student_avatar, :count_homework => count_homework, state: state }}
      all_students.merge!(student_info)
    end

    if session.state == Learning::Constant::Batch::Session::STATE_DONE
      session_students = session.op_attendance_lines

      session_students.each do |st|
        note = st.note_1
        note = st.note_2 unless note.blank?
        student = st.op_student
        student_avatar = get_student_avatar student
        state = ''
#        status = st.present ? 'on' : 'off'

        student_info = {student.id => {:note => note || '', :attendance => st.present, :code => student.code || '', :name => student.full_name || '', :avatar_src => student_avatar, state: state }}
        students.merge!(student_info)
      end
    end

    all_students.each do |k, _|
      all_students[k].merge!( students[k]) if students[k].present?
    end

    all_students
  end

  def self.teaching_schedule session_list, params
    if params[:date].present?
      if session_list.kind_of?(Array)
        sessions = []
        session_list.each {|list| sessions << list.where(:start_datetime => params[:date].to_time.all_week)}
      else
        sessions = session_list.where(:start_datetime => params[:date].to_time.all_week)
      end
    else
      if session_list.kind_of?(Array)
        sessions = []
        session_list.each {|list| sessions << list.where(:start_datetime => Time.now.all_week)}
      else
        sessions = session_list.where(:start_datetime => Time.now.all_week)
      end
    end

    sessions = sessions.to_a
    sessions.flatten!
    sessions.select! {|session| session if session.present?}
    schedule_hash = {'s1' => {}, 's2' => {}, 'c1' => {}, 'c2' => {}, 't1' => {}, 't2' => {}}

    sessions.each do |session|
      time = session.start_datetime
      name = session.op_subject.name
      end_time = session.end_datetime.strftime('%H:%M')
      start_time = time.strftime('%H:%M')
      day = time.strftime('%Y-%m-%d')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch
      batch_name = batch.name
      faculty = session.op_faculty ? session.op_faculty.full_name : ""
      classroom = session.classroom_id.nil? ? '' : Common::OpClassroom.find(session.classroom_id).name
      href = "/user/open_educat/op_teacher/teacher_class_detail?batch_id=#{ batch.id }&session_id=#{ session.id }"

      batch_class_online = session.op_batch.is_online?
      # batch_class = session.op_batch.is_online_class
      course = session.op_batch.op_course.name
      lesson = session.op_batch.current_session_level
      status = session.state

      session_info = { batch_class_online: batch_class_online, name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch_name, course: course, lesson: lesson, status: status, faculty: faculty, classroom: classroom, href: href }
      record = { time.wday => session_info}
      record[7] = record[0]

      case time.hour.to_i
      when 8..9
        schedule_hash['s1'].merge!(record)
      when 10..12
        schedule_hash['s2'].merge!(record)
      when 13..14
        schedule_hash['c1'].merge!(record)
      when 15..17
        schedule_hash['c2'].merge!(record)
      when 18..19
        schedule_hash['t1'].merge!(record)
      when 20..24
        schedule_hash['t2'].merge!(record)
      else
        # type code here
      end
    end
    
    schedule_hash
  end

  def self.checkin_report teacher
    sessions = teacher.op_sessions.where(start_datetime: Time.now.all_month, state: Learning::Constant::Batch::Session::STATE_DONE)
    report = {
      checkin: 0,
      none: 0,
      late: 0
    }
    sessions.each do |session|
      if session.check_in_state == 'good'
        report[:checkin] += 1
      elsif session.check_in_state == 'late'
        report[:late] += 1
      else
        report[:none] += 1
      end
    end

    report
  end

  def self.attendance_report teacher
    sessions = teacher.op_sessions.where(start_datetime: Time.now.all_month, state: Learning::Constant::Batch::Session::STATE_DONE)
    report = {
      match: 0,
      unmatch: 0,
      undefined: 0
    }
    sessions.each do |session|
      if session.attend_match == 'true'
        report[:match] += 1
      elsif session.attend_match == 'false'
        report[:unmatch] += 1
      else
        report[:undefined] += 1
      end
    end

    report

  end

  def self.teacher_evaluate user, params, teacher
    evaluate_content = {}
    params[:info].each{|k,v| evaluate_content.merge!({v['name'] => v['value']})}
    faculty_id = teacher.id
    session_id = evaluate_content['session_id']
    attendance = Learning::Batch::OpAttendanceLine.where(session_id: evaluate_content['session_id'], student_id: evaluate_content['student_id']).first

    if Learning::Batch::OpSessionsService.new.can_update_attendance_line? user, attendance
      evaluate_content.delete('session_id')
      evaluate_content.delete('studen_id')

      errors = Api::Odoo.evaluate(session_id: session_id.to_i, faculty_id: faculty_id, attendance_lines: [evaluate_content], attendance_time: Time.now)

      if errors == true
        attendance.update(attendance_state: OpAttendanceLineConstant::State::STATE_COMPLETED, evaluate_completed_time: Time.now )
        { type: 'success', message: 'Đánh giá thành công' }
      else
        { type: 'danger', message: errors[1] }
      end
    else
      { type: 'danger', message: "Bạn đã hoàn thành đánh giá! Không thể cập nhật đánh giá" }
    end
  end

  def get_student_avatar student
    student_avatar = ActionController::Base.helpers.asset_path('global/images/icon-student.png')
    #Temporary comment. TODO: in version 1.1
    user = User::Account::User.where(student_id: student.id).first

    if user.present?
      if student.gender == 'm'
        student_avatar = ActionController::Base.helpers.asset_path('global/images/Group-3.png')
      elsif student.gender == 'f'
        student_avatar = ActionController::Base.helpers.asset_path('global/images/Group-5.png')
      else
        student_avatar = ActionController::Base.helpers.asset_path('global/images/icon-student.png')
      end
    end

    student_avatar
  end

  def count_student_homework student, session
    user = User::Account::User.where(student_id: student.id).first
    lesson = session.op_lession

    return '' if user.blank? || lesson.blank?

    user_question_ids = Learning::Homework::UserQuestion.joins(:question).where(student_id: user.id).where(questions: { op_lession_id: lesson.id, question_type: 'text'}).pluck(:id)
    return 'Chưa có BTVN' if user_question_ids.blank?

    done_questions = Learning::Homework::UserAnswer.where(state: ['right', 'waiting'], user_question_id: user_question_ids).count
    "#{ done_questions }/#{ user_question_ids.count }"
  end
end
