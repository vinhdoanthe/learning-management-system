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
      sessions = Learning::Batch::OpSession.
                  includes(
                    { op_batch: :op_course },
                    :res_company, :photos,
                    { op_lession: :questions },
                    :op_faculty,
                    :op_attendance_lines).
                  where(query).
                  where(start_datetime: (params[:start_time].to_datetime..params[:end_time].to_datetime)).
                  distinct.
                  order(start_datetime: :DESC).
                  limit(25).
                  offset(offset).
                  pluck(
                    :id,
                    :state,
                    :start_datetime,
                    :end_datetime,
                    'op_batch.code',
                    'op_batch.id',
                    'op_batch.company_id',
                    'res_company.name',
                    'op_lession.name',
                    'op_lession.id',
                    'op_session.count',
                    'op_lession.lession_number',
                    'op_faculty.full_name',
                    'op_faculty.id',
                    'op_course.name',
                    "CASE WHEN EXISTS (SELECT id FROM questions WHERE questions.op_lession_id = op_lession.id) THEN 'true' ELSE 'false' END AS question"
                  )
    else
      sessions = Learning::Batch::OpSession.
                  includes(
                    { op_batch: :op_course },
                    :res_company ,
                    :photos,
                    { op_lession: :questions },
                    :op_faculty,
                    :op_attendance_lines).
                  where(query).
                  where(start_datetime: Time.at(0)..Time.now).
                  distinct.
                  order(start_datetime: :DESC).
                  limit(25).
                  offset(offset).
                  pluck(
                    :id,
                    :state,
                    :start_datetime,
                    :end_datetime,
                    'op_batch.code',
                    'op_batch.id',
                    'op_batch.company_id',
                    'res_company.name',
                    'op_lession.name',
                    'op_lession.id',
                    'op_session.count',
                    'op_lession.lession_number',
                    'op_faculty.full_name',
                    'op_faculty.id',
                    'op_course.name',
                    "CASE WHEN EXISTS (SELECT id FROM questions WHERE questions.op_lession_id = op_lession.id) THEN 'true' ELSE 'false' END AS question"
                  )
    end

    sessions.map!{ |info| { id: info[0], state: info[1], start_datetime: info[2], end_datetime: info[3], batch_id: info[5], batch_code: info[4], company_id: info[6], company_name: info[7], lesson_name: info[8], lesson_id: info[9], session_count: info[10], lesson_number: info[11], faculty_name: info[12], faculty_id: info[13], course_name: info[14], question: info[15].to_boolean } }

    session_ids = sessions.map{ |s| s[:id] }
    count_att_line = Learning::Batch::OpAttendanceLine.where(session_id: session_ids).group(:session_id).count
    count_ss_student = Learning::Batch::OpSessionStudent.where(session_id: session_ids).group(:session_id).count
    count_photo = SocialCommunity::Photo.where(session_id: session_ids).group(:session_id).count

    sessions.each do |session|
      session.merge! ( { count_attendance_line: count_att_line[session[:id]], count_session_student: count_ss_student[session[:id]], count_photo: count_photo[session[:id]] })
    end

    sessions
  end

  def session_student_homework params
    session_ids = params[:sessions]

    total_student_query = "SELECT session.id, COUNT(att) AS total_student, array_agg(student.id) AS student_ids
                            FROM op_session AS session
                            JOIN op_attendance_line AS att ON att.session_id = session.id
                            JOIN op_student as student ON att.student_id = student.id
                            WHERE session_id IN (#{ session_ids.join(', ')})
                            AND att.present = true
                            GROUP BY session.id"
    total_student = ActiveRecord::Base.connection.execute(total_student_query).as_json

    student_ids = []
    result = {}
    lesson_ids = Learning::Batch::OpSession.where(id: session_ids).pluck(:id, :lession_id)
    session_lesson = lesson_ids.to_h
    lesson_session = {}

    session_lesson.each do |k, v|
      if lesson_session[v].present?
        lesson_session[v] << k
      else
        lesson_session[v] = [k]
      end
    end

    session_student = {}

    total_student.each do |data|
      st_ids = data["student_ids"][1..-2].split(',')
      student_ids << st_ids.map(&:to_i)
      session_student[data["id"]] = st_ids.map(&:to_i)
      result.merge!({ data[0] => {total_student: data[1]} })
    end

    student_ids.flatten!
    students = User::OpenEducat::OpStudent.where(id: student_ids).pluck(:id, :full_name)
    student_info = students.to_h

    sql=" SELECT student_id, op_lession_id , COUNT(*) FILTER (WHERE right_total > 0) AS total_right_answers, COUNT(*) AS total_questions
          FROM (
            SELECT u.student_id, qq.op_lession_id, q.question_id, COUNT(*) FILTER(WHERE a.state = 'right') AS right_total
            FROM user_questions AS q
            LEFT JOIN user_answers AS a ON a.user_question_id = q.id
            JOIN questions AS qq ON qq.id = q.question_id
            JOIN op_lession AS l ON l.id = qq.op_lession_id
            JOIN users AS u ON u.id = q.student_id
            JOIN op_student as student on student.id = u.student_id
            WHERE student.id IN (#{ student_ids.join(', ')})
            GROUP BY u.student_id, qq.op_lession_id, q.question_id
          ) AS student_answers_report
          WHERE op_lession_id IN (#{ session_lesson.values.join(', ') })
          GROUP BY student_id, op_lession_id"
    question_data = ActiveRecord::Base.connection.execute(sql).as_json

    lesson_questions = {}
    question_data.each do |data|
      l_question = lesson_questions[data["op_lession_id"]]
      if l_question.present?
        l_question.merge!({ data["student_id"] => { total_question: data["total_questions"], right_question: data["total_right_answers"] } } )
      else
        lesson_questions[data["op_lession_id"]] = { data["student_id"] => { total_question: data["total_questions"], right_question: data["total_right_answers"] } }
      end
    end

    session_question = {}

    lesson_questions.each do |k ,v|
      lesson_session[k].each do |l_s|
        session_question.merge!({l_s => v})
      end
    end

    result = {}

    session_student.each do |s, student_arr|
      result[s] = {}
      student_arr.each do |student_id|
        session_question[s][student_id][:student_name] = student_info[student_id]
        if result[s].present? && result[s][student_id].present?
          result[s][student_id] << session_question[s][student_id]
        else
          result[s][student_id] = [session_question[s][student_id]]
        end
      end
    end

    report_data = {}

    result.each do |s_id, data|
      total_student = data.count
      total_question = 0
      total_right_answer = 0

      data.each do |k, v|
        total_question += v[0][:total_question]
        total_right_answer += v[0][:right_question]
      end

      inventory_question = total_question - total_right_answer
      report_data[s_id] = { total_student: total_student, total_question: total_question, total_right_answer: total_right_answer, inventory_question: inventory_question}
    end

    [result, report_data]
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
