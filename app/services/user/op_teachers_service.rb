class User::OpTeachersService
  def self.filter_batch(teacher, params)
    @batches ||= teacher.op_batches
    query = ''

    if params[:active] && params[:active] != 'all'
      query += "active = '#{params[:active]}' AND "
    end

    query += "op_batch.company_id = #{params[:company]} AND " unless params[:company].blank? || params[:company] == 'all' 
    query = query[0..-5]
    total_class = @batches.where(query)

    if params[:start_date].present?
      @class = total_class.where.not('start_date >= ? OR end_date <= ?', params[:end_date].to_time.utc.strftime('%Y-%m-%d'), params[:start_date].to_time.utc.strftime('%Y-%m-%d'))
    else
      query = "start_date >= '#{(Time.now - 1000.days).to_time.utc.strftime('%Y-%m-%d')}'"
      @class = total_class.where(query)
    end
    @class
  end

  def teacher_class_detail (batch, session)
    students = {}
    all_students = {}

    student_courses = batch.op_student_courses

    student_courses.each do |sst|
      student = sst.op_student
      student_info = {student.id => {:note => '', :status => sst.state, :attendance => '', :code => student.code, :name => student.full_name}}
      all_students.merge!(student_info)
    end

    if session.state == 'confirm'
      session_students = session.op_session_students
      session_students.each do |st|
        student = st.op_student_course.op_student
        student_info = {student.id => {:note => st.note, :attendance => '', :status => st.op_student_course.state, :code => student.code, :name => student.full_name}}
        students.merge!(student_info)
      end
    elsif session.state == 'done'
      session_students = session.op_attendance_lines
      session_students.each do |st|
        note = st.note_1
        note = st.note_2 unless note
        student = st.op_student
        student_info = {student.id => {:note => note, :attendance => st.present, :status => 'on', :code => student.code, :name => student.full_name}}
        students.merge!(student_info)
      end
    end

    all_students.each do |k,_|
      all_students[k] = students[k] if students[k].present?
    end

    all_students
  end
end