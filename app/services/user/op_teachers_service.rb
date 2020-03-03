class User::OpTeachersService
  def self.filter_batch(teacher, params)
    @batches ||= teacher.op_batches
    query = ''

    if params[:active] && params[:active] != 'all'
      if params[:active] == 'true'
        query += "op_session.active = true AND "
      else
        query += "op_session.active = false AND "
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

  def teacher_class_detail (batch, session)
    students = {}
    all_students = {}

    student_courses = batch.op_student_courses

    student_courses.each do |sst|
      student = sst.op_student
      student_info = {student.id => {:note => '', :status => sst.state, :attendance => '', :code => student.code || '', :name => student.full_name || ''}}
      all_students.merge!(student_info)
    end

    if session.state == Learning::Constant::Batch::Session::STATE_CONFIRM
      session_students = session.op_session_students
      session_students.each do |st|
        student = st.op_student_course.op_student
        student_info = {student.id => {:note => st.note || '', :attendance => '', :status => st.op_student_course.state, :code => student.code || '', :name => student.full_name}}
        students.merge!(student_info)
      end
    elsif session.state == Learning::Constant::Batch::Session::STATE_DONE
      session_students = session.op_attendance_lines
      session_students.each do |st|
        note = st.note_1
        note = st.note_2 unless note
        student = st.op_student
        student_info = {student.id => {:note => note || '', :attendance => st.present, :status => 'on', :code => student.code || '', :name => student.full_name || ''}}
        students.merge!(student_info)
      end
    end

    all_students.each do |k, _|
      all_students[k] = students[k] if students[k].present?
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
      time = session.end_datetime
      name = session.name
      start_time = session.start_datetime.strftime('%H:%M')
      end_time = time.strftime('%H:%M')
      day = time.strftime('%Y-%m-%d')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch.name
      course = session.op_batch.op_course.code
      lesson = session.count
      status = session.state

      session_info = {name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch, course: course, lesson: lesson, status: status}
      record = {time.wday => session_info}
      record['7'] = record['0']

      case time.hour.to_i
      when 8..10
        schedule_hash['s1'].merge!(record)
      when 10..12
        schedule_hash['s2'].merge!(record)
      when 12..14
        schedule_hash['c1'].merge!(record)
      when 14..16
        schedule_hash['c2'].merge!(record)
      when 16..18
        schedule_hash['t1'].merge!(record)
      when 18.20
        schedule_hash['t2'].merge!(record)
      else
        # type code here
      end
    end

    schedule_hash
  end

  def self.teacher_evaluate params
    attendance_line = Learning::Batch::OpAttendanceLine.where(:session_id => params[:session_id].to_i, :student_id => params[:student_id].to_s)
    return {type: 'danger', message: 'Vui lòng điểm danh trước!'} if attendance_line.blank?
    error = attendance_line.update(
        "knowledge1" => params['knowledge1'].to_i,
        "knowledge2" => params['knowledge2'].to_i,
        "knowledge3" => params['knowledge3'].to_i,
        "knowledge4" => params['knowledge4'].to_i,
        "attitude1" => params['attitude1'].to_i,
        "attitude2" => params['attitude2'].to_i,
        "skill1" => params['skill1'].to_i,
        "skill2" => params['skill2'].to_i,
        "note_1" => params['teacher_note']
    )

    if error
      return {type: 'success', message: 'Gửi đánh giá thành công!'}
    else
      return {type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!'}
    end
  end

end
