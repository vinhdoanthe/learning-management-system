class User::OpStudentsService
  def self.batch_state student
    batch_states = {}
    student.op_student_courses.each do |course|
      batch_states.merge!({ course.batch_id => course.state})
    end
    batch_states
  end

  def self.student_homework params, student
    student_subject_id = student.op_sessions.pluck(:subject_id)
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

        op_student_course = Learning::Batch::OpStudentCourse.where(batch_id: batch.id, student_id: student.id).last
        subject_ids = []
        unless op_student_course.nil?
          subject_ids = op_student_course.op_subjects.pluck(:id).uniq.compact
        end
        sessions = Learning::Batch::OpBatchService.get_sessions_without_cancel(batch.id, student.id, subject_ids)
        
        # sessions = student.op_sessions.where(batch_id: batch.id)
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

      sessions = Learning::Batch::OpBatchService.get_sessions_without_cancel(batch.id, student.id, subject.id)
      
      # sessions = sessions.where(subject_id: subject.id)
      session = sessions[-1] 
    end
    
    sessions = Learning::Batch::OpBatchService.get_sessions_without_cancel(batch.id, student.id, subject.id)
    # sessions = sessions.where(subject_id: subject.id).where.not(state: Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC)
    
    {batch: batch, batches: batches, session: session, sessions: sessions, subject: subject, subjects: subjects, course: course, show_video: show_video, errors: ''}
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
end
