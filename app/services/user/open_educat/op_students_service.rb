class User::OpenEducat::OpStudentsService
  def self.batch_state student
    batch_states = {}
    student.op_student_courses.each do |course|
      batch_states.merge!({ course.batch_id => course.state})
    end
    batch_states
  end

  def student_homework student
    op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student.id)
    batch_ids = op_student_courses.pluck(:batch_id)
    batches = Learning::Batch::OpBatch.where(id: batch_ids)
    active_session =  Learning::Batch::OpBatchService.last_done_session(student.id, batch_ids)

    if active_session.present?
      batch = active_session.op_batch
      subject = active_session.op_subject
      subjects = Learning::Course::OpSubject.where(id: batch.op_sessions.pluck(:subject_id).uniq)
      sessions = Learning::Batch::OpBatchService.get_sessions( batch_id = batch.id, student_id = student.id, subject_ids = subject.id).select{|s| s.state != Learning::Constant::Batch::Session::STATE_CANCEL}
      course = batch.op_course
      lesson = active_session.op_lession

      { batch: batch, batches: batches, session: active_session, sessions: sessions, subject: subject, subjects: subjects, course: course, errors: '', lesson: lesson }
    else
      { errors: true }
    end
  end

  def self.student_homework params, student
    student_subject_id = student.op_sessions.pluck(:subject_id).uniq
    student_batch_ids = student.op_batches.pluck(:id).uniq
    show_video = false

    if params[:session].present?
      session = Learning::Batch::OpSession.find(params[:session])
      batch = session.op_batch
      course = batch.op_course
      sessions = batch.op_sessions.where(subject_id: student_subject_id)
      batches = course.op_batches.where("op_batch.id IN (#{student_batch_ids.join(', ')})")
      show_video = true
    else
      if params[:course].blank? && params[:batch].blank? && params[:subject].blank?
        session = student.op_sessions.where('end_datetime <= ? AND op_session.state = ?', Time.now, Learning::Constant::Batch::Session::STATE_DONE).order(start_datetime: :DESC).first
        session = student.op_sessions.first if session.blank?
        return { errors: 'Học sinh chưa có lớp học nào' } if session.blank?
        batch = session.op_batch
        sessions = student.op_sessions.where(batch_id: batch.id)
        course = batch.op_course
        batches = course.op_batches.where(id: student_batch_ids).uniq
      else
        course = Learning::Course::OpCourse.find(params[:course])
        batches = course.op_batches.where("op_batch.id IN (#{student_batch_ids.join(', ')})")
        batch_ids = batches.pluck(:id)

        if batch_ids.include? params[:batch].to_i
          batch = batches.find(params[:batch])
          sessions = batch.op_sessions.where(subject_id: student_subject_id)
          session = sessions.where('end_datetime <= ? AND op_session.state = ?', Time.now, Learning::Constant::Batch::Session::STATE_DONE).order(start_datetime: :DESC).first
          session = sessions.first if session.blank?
        else
          session = student.op_sessions.where('op_session.course_id = ? AND end_datetime <= ? AND op_session.state = ?', course.id, Time.now, Learning::Constant::Batch::Session::STATE_DONE).order(start_datetime: :DESC).first
          session = student.op_sessions.where(course_id: course.id).first if session.blank?
          batch = session.op_batch
          sessions = batch.op_sessions.where(subject_id: student_subject_id)
        end
      end
    end

    subject = session.op_subject
    subjects = []
    sessions.each{|session| subjects << session.op_subject}
    subjects = subjects.uniq.sort_by{|s| s.level}

    if params[:subject].present?
      subject = Learning::Course::OpSubject.find(params[:subject])
      sessions = sessions.where(subject_id: subject.id)
      session = sessions.order(start_datetime: :DESC).first 
    end

    sessions = sessions.where(subject_id: subject.id).where.not(state: Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC)
    lesson = session.op_lession

    {batch: batch, batches: batches, session: session, sessions: sessions, subject: subject, subjects: subjects, course: course, show_video: show_video, errors: '', lesson: lesson}
  end

  def self.get_comming_soon_session(student_id)
    coming_soon_session = nil
    op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id).to_a
    batch_ids = []
    subject_ids = []
    student_course_ids = []
    op_student_courses.each do |op_student_course|
      student_course_ids << op_student_course.id
      batch_ids << op_student_course.batch_id
      subject_ids.concat op_student_course.op_subjects.pluck(:id).uniq
    end
    time_now = Time.now()
    next_sessions = Learning::Batch::OpSession.where('batch_id IN (?) AND subject_id IN (?) AND start_datetime >= ?', batch_ids, subject_ids, time_now).order(start_datetime: :ASC).to_a
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

  def course_product
    course_ids = Learning::Course::OpCourse.pluck(:name, :id).uniq
    # course_product = SocialCommunity::ScProduct.where(course_id: course_ids)
    course_products = []
    course_ids.each do |course|
      products = SocialCommunity::ScProduct.where(course_id: course[1]).order(created_at: :DESC).limit(10).to_a
      course_products << { course[0] => products }
    end
    course_products.select!{|t| t.values.flatten.present?}
    course_products
  end

  def timetable sessions
    schedule_hash = {'s1' => {}, 's2' => {}, 'c1' => {}, 'c2' => {}, 't1' => {}, 't2' => {}}

    sessions.each do |session|
      time = session.end_datetime
      name = session.op_subject.name
      start_time = session.start_datetime.strftime('%H:%M')
      end_time = time.strftime('%H:%M')
      day = time.strftime('%Y-%m-%d')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch
      batch_name = batch.name
      faculty = session.op_faculty ? session.op_faculty.full_name : ""
      classroom = session.classroom_id.nil? ? '' : Common::OpClassroom.find(session.classroom_id).name

      batch_class_online = session.op_batch.company_id == 35 ? true : false
      # batch_class = session.op_batch.is_online_class
      course = session.op_batch.op_course.name
      lesson = session.op_batch.current_session_level
      status = session.state

      session_info = { batch_class_online: batch_class_online, name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch_name, course: course, lesson: lesson, status: status, faculty: faculty, classroom: classroom}
      record = { time.wday => session_info}
      record[7] = record[0]

      case time.hour.to_i
      when 8..10
        schedule_hash['s1'].merge!(record)
      when 10..12
        schedule_hash['s2'].merge!(record)
      when 12..14
        schedule_hash['c2'].merge!(record)
      when 16..18
        schedule_hash['t1'].merge!(record)
      when 18..20
        schedule_hash['t2'].merge!(record)
      else
        # type code here
      end
    end

    schedule_hash
  end

  def self.get_featured_photos student_id
    batch_ids, subject_ids = get_batch_subject_ids student_id
    session_ids = Learning::Batch::OpSession.where(batch_id: batch_ids, subject_id: subject_ids).pluck(:id)
    SocialCommunity::Photo.where(session_id: session_ids).to_a
  end

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
end
