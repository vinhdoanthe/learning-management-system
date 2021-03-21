class Learning::Course::OpSubjectsController < ApplicationController
  
  def assign_session
    subject = Learning::Course::OpSubject.where(id: params[:subject_id]).first
    return if subject.blank?
    
    sessions = subject.op_sessions.where(batch_id: params[:batch_id]).where.not(state: Learning::Constant::Batch::Session::STATE_CANCEL).order(start_datetime: :ASC)
    active_session = sessions.where(faculty_id: params[:teacher_id]).where('start_datetime >= ?', Time.now).first
    active_session = sessions.where(faculty_id: params[:teacher_id]).last if active_session.blank?
    active_session = sessions.last if active_session.blank?
    assign_sessions = sessions

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/session_subject_timeline', locals: { active_session: active_session, assign_sessions: assign_sessions, subject: subject }}
    end

  end

  def subject_lesson
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first

    if session.blank?
      respond_to do |format|
        format.html
        format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/chosen_lesson', locals: { success: false, noti: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau nhé!' } } }
      end
      return
    end

    batch = session.op_batch

    unless session.is_offset
      start_time = session.start_datetime.utc
      end_time = (session.end_datetime - 3.days).utc
      sql = " SELECT student_id
            FROM op.student.batch.report
            WHERE batch_id = #{ batch.id }
            AND start_datetime <= '#{ start_time }'
            AND end_datetime >= '#{ end_time }'
            AND state = 'on'"
      total_student = ActiveRecord::Base.connection.execute(sql).values
      student_ids = total_student.flatten
    else
      student_ids = session.op_session_students.pluck(:student_id)
    end

    students = User::OpenEducat::OpStudent.where(id: student_ids).pluck(:id, :code, :full_name)

    all_student = {}
    students.each do |s|
      all_student.merge!({ s[0] => { status: 'on', code: s[1], name: s[2] }})
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
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/chosen_lesson', locals: { lessons: lessons, all_student: all_student, success: true } }
    end
  end
end
