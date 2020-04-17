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
    subject = session.op_subject
    lessons = [session.op_lession]
    lessons = subject.op_lessions if lessons.blank?

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/chosen_lesson', locals: { lessons: lessons } }
    end
  end
end
