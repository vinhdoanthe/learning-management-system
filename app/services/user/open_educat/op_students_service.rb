class User::OpenEducat::OpStudentsService
  def self.get_attendance_report student_id
    Learning::Batch::Report::StudentAttendanceReport.new(student_id).subject_student_attendance_reports
  end

  def self.batch_state student
    batch_states = {}
    student.op_student_courses.each do |course|
      batch_states.merge!({ course.batch_id => course.state})
    end
    batch_states
  end

  def self.batch_subject_state student_id = nil, batch_id = nil, subject_id = nil, sessions = []
    return nil if student_id.nil? or batch_id.nil? or subject_id.nil?
    op_batch = Learning::Batch::OpBatch.where(id: batch_id).first
    return nil if op_batch.nil?
    if sessions.empty?
      sessions = Learning::Batch::OpSession.where(batch_id: batch_id, subject_id: subject_id).to_a 
    end 
    if op_batch.state == Learning::Constant::STUDENT_BATCH_STATUS_SAVE
      status = Learning::Constant::Batch::StudentSubject::STATE_SAVE
    elsif op_batch.state == Learning::Constant::STUDENT_BATCH_STATUS_OFF
      status = Learning::Constant::Batch::StudentSubject::STATE_OFF
    else
      tobe_sessions = sessions.select {|session| (session.state == Learning::Constant::Batch::Session::STATE_DRAFT or session.state == Learning::Constant::Batch::Session::STATE_CONFIRM)}
      status = (tobe_sessions.empty? ? Learning::Constant::Batch::StudentSubject::STATE_OFF : Learning::Constant::Batch::StudentSubject::STATE_ON)
    end
    status
  end

  def student_homework student, params
    if params[:session].present?
      op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student.id)
      active_session = Learning::Batch::OpSession.where(id: params[:session]).first
    else
      op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student.id)
      batch_ids = op_student_courses.pluck(:batch_id)
      active_session = Learning::Batch::OpBatchService.last_done_session(student.id, batch_ids)
    end

    if active_session.present?
      batch = active_session.op_batch
      subject = active_session.op_subject
      student_course = Learning::Batch::OpStudentCourse.where(student_id: student.id, batch_id: batch.id).first
      subjects = student_course.op_subjects
#      subjects = Learning::Course::OpSubject.where(id: batch.op_sessions.pluck(:subject_id).uniq)
      sessions = Learning::Batch::OpBatchService.get_sessions( batch_id = batch.id, student_id = student.id, subject_ids = subject.id).select{|s| s.state != Learning::Constant::Batch::Session::STATE_CANCEL}
      course = batch.op_course
      lesson = active_session.op_lession
      batch_of_course = op_student_courses.where(course_id: active_session.course_id).pluck(:batch_id).uniq

      if batch_of_course.blank?
        batch_of_course = batch.id
      end

      batches = Learning::Batch::OpBatch.where(id: batch_of_course)

      { batch: batch, batches: batches, session: active_session, sessions: sessions, subject: subject, subjects: subjects, course: course, errors: '', lesson: lesson }
    else
      { errors: true }
    end
  end

  def self.get_comming_soon_session(student_id)
    coming_soon_session = nil
    op_student_courses = Learning::Batch::OpStudentCourse.joins(:op_batch).where(op_batch: { state: Learning::Constant::Batch::STATE_APPROVE }).where(student_id: student_id).to_a
    batch_ids = []
    subject_ids = []
    student_course_ids = []
    op_student_courses.each do |op_student_course|
      next if op_student_course.state != Learning::Constant::STUDENT_BATCH_STATUS_ON
      student_course_ids << op_student_course.id
      batch_ids << op_student_course.batch_id
      subject_ids.concat op_student_course.op_subjects.pluck(:id).uniq
    end
    time_now = Time.now()
    next_sessions = Learning::Batch::OpSession.where('batch_id IN (?) AND subject_id IN (?) AND start_datetime >= ? AND state != ?', batch_ids, subject_ids, time_now, Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC).to_a
    next_sessions.each do |session|
      if !session.is_offset
        coming_soon_session = session
        break
      else
        session_student = Learning::Batch::OpSessionStudent.where(session_id: session.id, student_course_id: student_course_ids).first
        if !session_student.nil?
          coming_soon_session = session
          break
        end
      end 
    end 
    coming_soon_session
  end

  def self.coming_soon_lesson coming_soon_session, student_id
    return nil if coming_soon_session.nil?
    if !coming_soon_session.lession_id.nil?
      coming_soon_lesson = coming_soon_session.op_lession
    else
      # find last done session of a student
      last_att_line = Learning::Batch::OpAttendanceLine.where(student_id: student_id, batch_id: coming_soon_session.batch_id).last
      return nil if last_att_line.nil?
      att = last_att_line.op_attendance_sheet
      return nil if att.nil?
      lesson = att.op_lession
      return nil if lesson.nil?
      courses_service = Learning::Course::OpCoursesService.new(coming_soon_session.course_id)
      coming_soon_lesson = courses_service.get_next_lesson(lesson.id)
    end
    coming_soon_lesson
  end

  def course_product
    course_ids = Learning::Course::OpCourse.pluck(:name, :id).uniq
    # course_product = SocialCommunity::ScProduct.where(course_id: course_ids)
    course_products = []
    course_ids.each do |course|
      products = SocialCommunity::ScStudentProject.where(course_id: course[1]).order(created_at: :DESC).limit(10).to_a
      course_products << { course[0] => products }
    end
    course_products.select!{|t| t.values.flatten.present?}
    course_products
  end

  def timetable sessions
    schedule_hash = {'s1' => {}, 's2' => {}, 'c1' => {}, 'c2' => {}, 't1' => {}, 't2' => {}}

    sessions.each do |session|
      time = session.start_datetime
      name = session.op_subject.name
      start_time = time.strftime('%H:%M')
      end_time = session.end_datetime.strftime('%H:%M')
      day = time.strftime('%d-%m-%Y')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch
      batch_name = batch.name
      faculty = session.op_faculty ? session.op_faculty.full_name : ""
      classroom = session.classroom_id.nil? ? '' : Common::OpClassroom.find(session.classroom_id).name

      #      batch_class_online = session.op_batch.company_id == 35 ? true : false
      batch_class_online = batch&.is_online? 
      # batch_class = session.op_batch.is_online_class
      course = session.op_batch.op_course.name
      lesson = session.op_batch.current_session_level
      status = session.state
      href = "/user/open_educat/op_students/batch_detail/#{ batch.id }"

      session_info = { batch_class_online: batch_class_online, name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch_name, course: course, lesson: lesson, status: status, faculty: faculty, classroom: classroom, href: href }
      record = { time.wday => session_info}
      record[7] = record[0]

      #case time.hour.to_i
      #when 8..9
      #  schedule_hash['s1'].merge!(record)
      #when 10..12
      #  schedule_hash['s2'].merge!(record)
      #when 13..15
      #  schedule_hash['c1'].merge!(record)
      #when 16..17
      #  schedule_hash['c2'].merge!(record)
      #when 18..19
      #  schedule_hash['t1'].merge!(record)
      #when 20..24
      #  schedule_hash['t2'].merge!(record)
      #else
      #  # type code here
      #end

      case time.hour.to_i
      when 8..12
        si = 1
        while schedule_hash['s' + si.to_s][time.wday].present? do
          si += 1
        end
        schedule_hash['s' + si.to_s] = {} if schedule_hash['s' + si.to_s].blank?
        schedule_hash['s' + si.to_s].merge!(record)
      when 13..17
        c1 = 1
        while schedule_hash['c' + c1.to_s][time.wday].present? do
          c1 += 1
        end
        schedule_hash['c' + c1.to_s] = {} if schedule_hash['c' + c1.to_s].blank?
        schedule_hash['c' + c1.to_s].merge!(record)
      when 18..22
        t1 = 1
        while schedule_hash['t' + t1.to_s][time.wday].present? do
          t1 += 1
        end
        schedule_hash['t' + t1.to_s] = {} if schedule_hash['t' + t1.to_s].blank?
        schedule_hash['t' + t1.to_s].merge!(record)
      end
    end

    schedule_hash
  end

  # def self.get_featured_photos student_id
  #   batch_ids, subject_ids = get_batch_subject_ids student_id
  #   session_ids = Learning::Batch::OpSession.where(batch_id: batch_ids, subject_id: subject_ids).pluck(:id)
  #   SocialCommunity::Photo.where(session_id: session_ids).to_a
  # end

  def self.get_batch_ids student_id
    op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id).to_a
    batch_ids = []
    student_course_ids = []
    op_student_courses.each do |op_student_course|
      student_course_ids << op_student_course.id
      batch_ids << op_student_course.batch_id
    end

    batch_ids
  end

  def self.get_batch_subject_ids student_id
    op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id).to_a
    batch_ids = []
    subject_ids = []
    student_course_ids = []
    op_student_courses.each do |op_student_course|
      student_course_ids << op_student_course.id
      batch_ids << op_student_course.batch_id
      subject_ids.concat op_student_course.op_subjects.pluck(:id).uniq
    end

    [batch_ids, subject_ids]
  end

  def self.get_products student_id

  end

  # return
  # - achievements
  # - badges
  # - products
  # - featured_photos
  def self.get_public_profile student_id
    count_homework = Learning::Homework::UserAnswerService.count_done_homework student_id
    op_student_courses = Learning::Batch::OpStudentCourse.includes(:op_batch, :op_course).where(student_id: student_id).to_a
    achievements = []
    badges = []
    products = []
    featured_photos = []
    products = SocialCommunity::ScStudentProject.where(student_id: student_id, 
                                                          state: SocialCommunity::Constant::ScStudentProject::State::PUBLISH, 
                                                          permission: SocialCommunity::Constant::ScStudentProject::Permission::PUBLIC).to_a
    [count_homework, op_student_courses, achievements, badges, featured_photos, products]
  end

  def student_batches student
    batch_info = []
    student_courses = student.op_student_courses

    if student_courses.present?
      student_courses.each do |sc|
        batch = sc.op_batch
        subject_info = sc.op_subjects.pluck(:id, :level)
        batch_type = batch.type_id.present? ? batch.op_batch_type.name : ''
        course = Learning::Course::OpCourse.where(id: sc.course_id).first

        batch_info << { batch_id: batch.id, batch_code: batch.code, course_id: course.id, course_name: course.name, subjects: subject_info, batch_type: batch_type, state: sc.state }
      end
    end

    batch_info
  end
end
