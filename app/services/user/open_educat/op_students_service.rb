class User::OpenEducat::OpStudentsService
  def self.get_attendance_report student_id
    report_objects = []
    op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student_id).uniq.to_a
    last_sessions = []
    op_student_courses.each do |op_student_course|
      subject_ids = op_student_course.op_subjects.pluck(:id).uniq.compact
      batch_code = op_student_course.op_batch.code
      subject_ids.each do |subject_id|
        sessions = Learning::Batch::OpBatchService.get_sessions(op_student_course.batch_id, student_id, [subject_id])

        done_sessions = sessions.select { |t| t.state == 'done' }
        if done_sessions.present?
          lastest_session = done_sessions.max { |t| t.start_datetime } 
          last_sessions << lastest_session
        end

        next if sessions.empty?
        count_object = Learning::Batch::OpSessionsService.report_attendance(sessions, student_id)
        next if count_object.empty?
        subject = Learning::Course::OpSubject.where(id: subject_id).first
        subject_level = subject.level
        course_name = subject.op_course.name
        report_object = {
          :batch_code => batch_code,
          :subject_level => subject_level,
          :course_name => course_name,
          :count => count_object
        }
        report_objects << report_object
      end
    end
    
    if last_sessions.present?
      active_session = last_sessions.flatten.compact.max { |t| t.start_datetime }
      active_batch_code = active_session.op_batch.code
      subject_level = Learning::Course::OpSubject.where(id: active_session.subject_id).first.level
      active_index = report_objects.find_index { |t| (t.values.include? active_batch_code) && (t.values.include? subject_level) }
      report_objects.unshift (report_objects[active_index])
      report_objects.delete_at(active_index + 1)
    end

    report_objects
  end

  def self.batch_state student
    batch_states = {}
    student.op_student_courses.each do |course|
      batch_states.merge!({ course.batch_id => course.state})
    end
    batch_states
  end

  def student_homework student, params
    if params[:session_id].present?
      op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student.id)
      active_session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    else
      op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: student.id)
      batch_ids = op_student_courses.pluck(:batch_id)
      active_session = Learning::Batch::OpBatchService.last_done_session(student.id, batch_ids)
    end

    if active_session.present?
      batch = active_session.op_batch
      subject = active_session.op_subject
      subjects = Learning::Course::OpSubject.where(id: batch.op_sessions.pluck(:subject_id).uniq)
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
      day = time.strftime('%Y-%m-%d')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch
      batch_name = batch.name
      faculty = session.op_faculty ? session.op_faculty.full_name : ""
      classroom = session.classroom_id.nil? ? '' : Common::OpClassroom.find(session.classroom_id).name

      #      batch_class_online = session.op_batch.company_id == 35 ? true : false
      batch_class_online = (['1', '2'].include? session.op_batch.select_place) ? false : true
      # batch_class = session.op_batch.is_online_class
      course = session.op_batch.op_course.name
      lesson = session.op_batch.current_session_level
      status = session.state

      session_info = { batch_class_online: batch_class_online, name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch_name, course: course, lesson: lesson, status: status, faculty: faculty, classroom: classroom}
      record = { time.wday => session_info}
      record[7] = record[0]

      case time.hour.to_i
      when 8..9
        schedule_hash['s1'].merge!(record)
      when 10..12
        schedule_hash['s2'].merge!(record)
      when 13..15
        schedule_hash['c1'].merge!(record)
      when 16..17
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
