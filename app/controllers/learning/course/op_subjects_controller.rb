class Learning::Course::OpSubjectsController < ApplicationController
  
  def assign_session
    subject = Learning::Course::OpSubject.where(id: params[:subject_id]).first
    return if subject.blank?
    
    sessions = subject.op_sessions.where(faculty_id: params[:teacher_id], batch_id: params[:batch_id]).order(start_datetime: :ASC)
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
    session_students = session.op_session_students
    all_student = {}

    session_students.each do |st|
      op_student_course = st.op_student_course
      next if op_student_course.blank?
      student = op_student_course.op_student
      next if student.blank?
      status = st.present ? 'on' : 'off'
      student_info = {student.id => {:status => status, :code => student.code || '', :name => student.full_name}}
      all_student.merge!(student_info)
    end

    subject = session.op_subject
    lessons = session.op_lession || []

    lessons = subject.op_lessions if lessons.blank?
    lessons = [nil] if lessons.blank?

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/chosen_lesson', locals: { lessons: lessons, all_student: all_student } }
    end
  end
end
