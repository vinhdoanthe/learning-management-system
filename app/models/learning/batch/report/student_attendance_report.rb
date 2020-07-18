class Learning::Batch::Report::StudentAttendanceReport
  attr_accessor :student_id
  attr_accessor :subject_student_attendance_reports

  def initialize student_id
    @student_id = student_id
    @subject_student_attendance_reports = []

    caculate_report
  end

  private
  def caculate_report
    op_student_courses = Learning::Batch::OpStudentCourse.includes(:op_batch).where(student_id: student_id).uniq.to_a
    op_student_courses = sort_op_student_courses(op_student_courses)
    op_student_courses.each do |op_student_course|
      subject_ids = op_student_course.op_subjects.order(:level => :ASC).pluck(:id).uniq.compact
      op_batch = op_student_course.op_batch
      next if op_batch.nil?
      batch_code = op_batch.code
      subject_ids.each do |subject_id|
        sessions = Learning::Batch::OpBatchService.get_sessions(op_student_course.batch_id, student_id, [subject_id])
        next if sessions.empty?
        count_object = Learning::Batch::OpSessionsService.report_attendance(subject_id, student_id, sessions)
        next if count_object.nil?
        status = User::OpenEducat::OpStudentsService.batch_subject_state(student_id, op_batch.id, subject_id, sessions)
        subject = Learning::Course::OpSubject.where(id: subject_id).first
        subject_level = subject.level
        course_name = subject.op_course.name
        report_object = {
          :batch_code => batch_code,
          :subject_level => subject_level,
          :status => status,
          :course_name => course_name,
          :count => {
            :tobe => count_object.tobe,
            :cancelled => count_object.cancelled,
            :present_yes => count_object.present_yes,
            :present_no => count_object.present_no
          }
        }
        @subject_student_attendance_reports << report_object
      end
    end

  end

  def sort_op_student_courses student_courses
    on_op_student_courses = student_courses.select {|student_course| student_course.state == Learning::Constant::STUDENT_BATCH_STATUS_ON}
    off_op_student_courses = student_courses.select {|student_course| student_course.state == Learning::Constant::STUDENT_BATCH_STATUS_OFF}
    save_op_student_courses = student_courses.select {|student_course| student_course.state == Learning::Constant::STUDENT_BATCH_STATUS_SAVE}
    on_op_student_courses = on_op_student_courses.sort_by {|student_course| student_course.create_date}
    save_op_student_courses = save_op_student_courses.sort_by {|student_course| student_course.create_date}
    off_op_student_courses = off_op_student_courses.sort_by {|student_course| student_course.create_date}
    on_op_student_courses + save_op_student_courses + off_op_student_courses
  end
end
