class Learning::Course::OpSubjectsController < ApplicationController
  
  def assign_session
    subject = Learning::Course::OpSubject.where(id: params[:subject_id]).first
    return if subject.blank?
    
    sessions = subject.op_sessions.where(faculty_id: params[:teacher_id], batch_id: params[:batch_id]).where.not(state: Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC)
    active_session = sessions.where('start_datetime >= ?', Time.now).first
    active_session = sessions.last if active_session.blank?
    assign_sessions = sessions

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/session_subject_timeline', locals: { active_session: active_session, assign_sessions: assign_sessions, subject: subject }}
    end

  end

  def subject_lesson
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    all_student = {}
    batch = session.op_batch
    student_courses = batch.op_student_courses.where(state: 'on')

    student_courses.each do |sc|
      student = sc.op_student
      next if student.blank?
      student_info = {student.id => {:status => 'on', :code => student.code || '', :name => student.full_name}}
      all_student.merge!(student_info)
    end

    if session.state == 'done'
      attendance = session.op_attendance_lines.order(create_date: :ASC)

      attendance.each do |att|
        student = att.op_student
        next if student.blank?
        student_info = { student.id => { status: (att.present ? 'on' : 'off'), code: student.code || '', name: student.full_name } }
        all_student.merge!(student_info)
      end
    end

    subject = session.op_subject
    lessons = [session.op_lession]

    lessons = subject.op_lessions if lessons.compact.blank?
    lessons = [] if lessons.blank?

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/chosen_lesson', locals: { lessons: lessons, all_student: all_student } }
    end
  end
end
