class Adm::Learning::SessionsService

  def session_index params, user
    offset = 0
    offset = ( params[:page].to_i ) * 25 if params[:page].present?
    query = ''
    allow_companies = get_allow_user_companies user
    query += "op_batch.id IN (#{ params[:batch_id].join(',') }) AND " if params[:batch_id].present?

    if params[:company_id].present?
      query += "op_batch.company_id IN (#{ params[:company_id].join(',') }) AND "
    elsif allow_companies.present?
      query += "op_batch.company_id IN (#{ allow_companies.join(',') }) AND "
    end

    if params[:state].present?
      state = convert_string_in_query params[:state]
      query += "op_session.state IN ( #{ state } ) AND " if params[:state].present?
    end

    if params[:photo_state] == '0'
      query += "photos.id IS NOT NULL AND " 
    elsif params[:photo_state] == '1'
      query += "photos.id IS NULL AND "
    end

    if params[:attendance] == '0'
      query += "op_attendance_line.id IS NULL AND "
    elsif params[:attendance] == '1'
      #query += "op_attendance_line.attendance_state NOT IN ('published', 'completed') AND "
      query += "op_attendance_line.id IS NOT NULL AND op_attendance_line.present = true AND ((op_attendance_line.attendance_state IS NULL) OR (op_attendance_line.attendance_state = '#{ OpAttendanceLineConstant::State::STATE_COMPLETED }')) AND "
    elsif params[:attendance] == '2'
      query += "op_attendance_line.attendance_state = '#{ OpAttendanceLineConstant::State::STATE_REJECTED }' AND "
    end

    query = query[0..-5]

    if query.blank?
      params[:start_time] = Time.now.beginning_of_day
      params[:end_time] = Time.now.end_of_day
    end

    if params[:start_time].present?
      sessions = Learning::Batch::OpSession.includes({ op_batch: :op_course }, :res_company, :photos, :op_lession, :op_faculty, :op_attendance_lines).where(query).where(start_datetime: (params[:start_time].to_datetime..params[:end_time].to_datetime)).distinct.order(start_datetime: :DESC).limit(25).offset(offset).pluck(:id, :state, :start_datetime, :end_datetime, 'op_batch.code', 'op_batch.id', 'op_batch.company_id', 'res_company.name', 'op_lession.name', 'op_lession.id', 'op_session.count', 'op_lession.lession_number', 'op_faculty.full_name', 'op_faculty.id', 'op_course.name')
    else
      sessions = Learning::Batch::OpSession.includes({ op_batch: :op_course }, :res_company , :photos, :op_lession, :op_faculty, :op_attendance_lines).where(query).where(start_datetime: Time.at(0)..Time.now).distinct.order(start_datetime: :DESC).limit(25).offset(offset).pluck(:id, :state, :start_datetime, :end_datetime, 'op_batch.code', 'op_batch.id', 'op_batch.company_id', 'res_company.name', 'op_lession.name', 'op_lession.id', 'op_session.count', 'op_lession.lession_number', 'op_faculty.full_name', 'op_faculty.id', 'op_course.name')
    end
    #sessions = Learning::Batch::OpSession.includes({ op_batch: :op_course }, :res_company , :photos, :op_lession, :op_faculty, :op_attendance_lines).where(query).where(start_datetime: Time.at(0)..Time.now).distinct.order(start_datetime: :DESC).group(:id, 'op_batch.code', 'op_batch.id', 'res_company.name', 'op_lession.name', 'op_lession.id', 'op_faculty.full_name', 'op_faculty.id', 'op_course.name').limit(25).offset(offset).pluck(:id, :state, :start_datetime, :end_datetime, 'op_batch.code', 'op_batch.id', 'op_batch.company_id', 'res_company.name', 'op_lession.name', 'op_lession.id', 'op_session.count', 'op_lession.lession_number', 'op_faculty.full_name', 'op_faculty.id', 'op_course.name', 'count(op_attendance_line.id)')

    sessions.map!{ |info| { id: info[0], state: info[1], start_datetime: info[2], end_datetime: info[3], batch_id: info[5], batch_code: info[4], company_id: info[6], company_name: info[7], lesson_name: info[8], lesson_id: info[9], session_count: info[10], lesson_number: info[11], faculty_name: info[12], faculty_id: info[13], course_name: info[14] } }

    sessions.each do |session|
      count_attendance_line = Learning::Batch::OpAttendanceLine.where(session_id: session[:id]).count
      count_session_student = Learning::Batch::OpSessionStudent.where(session_id: session[:id]).count
      session.merge!({ count_attendance_line: count_attendance_line, count_session_student: count_session_student})
    end

    sessions
  end

  def get_allow_user_companies user
    if user.is_operation_admin?
      user.user_companies.pluck(:company_id)
    else
      []
    end
  end

  def convert_string_in_query arr_str
    str = arr_str.to_s.gsub "\"", "'"
    str = str.delete ']'
    str = str.delete '['

    str
  end

  def session_students session, batch
    students = {}
    student_courses = batch.op_student_courses

    student_courses.each do |sc|
      student_name = sc.op_student.full_name
      info = { sc.student_id => { student_name: student_name, attendance_state: '', session_student_state: '', student_course_state: sc.state }}
      students.merge!(info)
    end

    session_students = session.op_session_students
    if session_students.present?
      session_students.each do |st|
        if students[st.student_id].present?
          students[st.student_id][:session_student_state] = st.present
        end
      end
    end

    session_attendances = session.op_attendance_lines
    if session_attendances.present?
      session_attendances.each do |sa|
        if students[sa.student_id].present?
          students[sa.student_id][:attendance_state] = sa.present
          students[sa.student_id][:attendance_id] = sa.id
        end
      end
    end

    students
  end
end
