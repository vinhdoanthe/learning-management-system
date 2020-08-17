class User::OpenEducat::OpTeachersController < ApplicationController
  before_action :find_teacher
  skip_before_action :verify_authenticity_token

  def teacher_class_detail
    if params[:session_id].present?
      @active_session = Learning::Batch::OpSession.where(id: params[:session_id]).first
      @active_lesson = @active_session.op_lession
      @batch = @active_session.op_batch
      @course = @batch.op_course
      @faculty = @teacher
      @sessions = @batch.op_sessions.where(faculty_id: @faculty.id).order(start_datetime: :ASC)
      classroom = Common::OpClassroom.where(id: @active_session.classroom_id).first
      @classroom_name = classroom ? classroom.name : ''
      company = @batch.res_company
      @company_name = company ? company.name : ''
      @active_subject = @active_session.op_subject
      subject_ids = @sessions.pluck(:subject_id)
      @subjects = Learning::Course::OpSubject.where(id: subject_ids).pluck(:id, :level).uniq
      @sessions = @sessions.where(subject_id: @active_subject.id)
      if @active_lesson && @active_lesson.thumbnail.attached?
        @thumbnail = url_for(@active_lesson.thumbnail)
      else
        @thumbnail = ActionController::Base.helpers.asset_path('global/images/default-lesson-thumbnail.png')
      end

    else
      @batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
      @course = @batch.op_course
      @faculty = @teacher
      @sessions = @batch.op_sessions.where(faculty_id: @faculty.id).order(start_datetime: :ASC)
      @active_session = @sessions.where('start_datetime >= ?', Time.now).first
      @active_session = @sessions.last if @active_session.blank?
      classroom = Common::OpClassroom.where(id: @active_session.classroom_id).first
      @classroom_name = classroom ? classroom.name : ''
      company = @batch.res_company
      @company_name = company ? company.name : ''
      @active_subject = @active_session.op_subject
      subject_ids = @sessions.pluck(:subject_id)
      @subjects = Learning::Course::OpSubject.where(id: subject_ids).pluck(:id, :level).uniq
      @sessions = @sessions.where(subject_id: @active_subject.id)
      @active_lesson = @active_session.op_lession

      if @active_lesson && @active_lesson.thumbnail.attached?
        @thumbnail = url_for(@active_lesson.thumbnail)
      else
        @thumbnail = ActionController::Base.helpers.asset_path('global/images/default-lesson-thumbnail.png')
      end
    end

  end

  def teacher_checkin
    errors = Api::Odoo.checkin(session_id: params[:session_id].to_i, faculty_id: params[:faculty_id].to_i, check_in_time: params[:time])

    if errors[0]
      error = {type: 'success', message: 'Checkin thành công'}
    else
      error = {type: 'danger', message: errors[1]}
    end

    render json: {error: error}
  end

  def teacher_attendance
    lines = []
    student_ids = []
    checkin_values = []
    errs = []
    errors = [true]

    unless params[:student].blank?
      params[:student].each_value do |student_params|
        student = User::OpenEducat::OpStudent.where(code: student_params['student_id']).first
        next if student.blank?

        student_id = student.id
        student_ids << student_id
        checkin_values << ActiveModel::Type::Boolean.new.cast(student_params['check'])

        if !validate_attendance student_id, params[:session_id]
          line = {}
          line[:student_id] = student_id
          line[:session_id] = params[:session_id].to_i
          line[:present] = ActiveModel::Type::Boolean.new.cast(student_params['check'])
          line[:note_1] = student_params['note'].to_s
          lines.append line
        else
          # puts "not exist"
          begin
            errs << Api::Odoo.evaluate(session_id: params[:session_id].to_s, faculty_id: @teacher.id, attendance_time: Time.now, attendance_lines: [{ present: ActiveModel::Type::Boolean.new.cast(student_params['check']), student_id: student_id }])
          rescue StandardError => e
            result = { noti: {type: 'danger', message: "Đã có lỗi xảy ra! Vui lòng thử lại sau!"} }
          end
        end
      end
    end
    lesson = Learning::Course::OpLession.where(id: params[:lesson_id].to_i).first
    lesson_name = (lesson.nil? ? '' : lesson.name)
    begin
      errors = Api::Odoo.attendance(session_id: params[:session_id].to_i, faculty_id: @teacher.id, attendance_time: Time.now, attendance_lines: lines, lession_id: params[:lesson_id].to_i, name: lesson_name) if lines.present?
    rescue StandardError => e
      result = { noti: {type: 'danger', message: "Đã có lỗi xảy ra! Vui lòng thử lại sau!"} }
    end

    if errors.present? && ( (errors[0] == true) || (errors.is_a? Integer) )
      unless student_ids.blank?
        student_ids.each do |student_id|
          user = User::Account::User.where(student_id: student_id).first
          next if user.blank?
          attendance_line = Learning::Batch::OpAttendanceLine.where(session_id: params[:session_id], student_id: student_id).first
          User::Reward::CoinStarsService.new.reward_coin_star attendance_line, user.id, 0
        end
      end

      student_codes = User::OpenEducat::OpStudent.where(id: student_ids).pluck(:code)
      response_values = []
      student_codes.each_with_index do |code, index|
        response_values << {
          :student_code => code,
          :checkin_value => checkin_values[index]
        }
      end

      result = { noti: {type: 'success', message: 'Điểm danh thành công!'}, data: response_values}
    else
      message = errors[1] if errors[1].present?
      message = 'Đã có lỗi xảy ra! Thử lại sau' if message.blank?

      result = { noti: {type: 'danger', message: message} }
    end

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/attendance_response', locals: result }
    end

  rescue StandardError => e
    redirect_error_site(e)
  end

  def teaching_schedule
  end

  def teaching_schedule_content
    @sessions = @teacher.op_sessions
    schedules = User::OpenEducat::OpTeachersService.teaching_schedule(@sessions, params)

    render json: {schedules: schedules}
  end

  def checkin_report
    result = User::OpenEducat::OpTeachersService.checkin_report @teacher

    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/teacher/js/checkin_report', locals: { reports: result } }
    end
  end

  def attendance_report
    report = User::OpenEducat::OpTeachersService.attendance_report @teacher

    respond_to do |format|
      format.html
      format.js { render 'social_community/dashboards/teacher/js/attendance_report', locals: { report: report } }
    end
  end

  def student_projects
    subject_student_projects = SocialCommunity::ScStudentProject.where(batch_id: params[:batch_id]).all.group_by{ |product| product.subject_id }
    subject_ids = subject_student_projects.keys
    subjects = Learning::Course::OpSubject.where(id: subject_ids).pluck(:id, :level)

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/student_projects', locals: { subject_student_projects: subject_student_projects, subjects: subjects } }
    end
  end

  def assign_homework_details
    result = true
    homeworks = nil
    students = nil

    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    result = false if session.blank?

    batch = session.op_batch
    lesson = session.op_lession
    result = false if lesson.blank?

    if result
      homeworks = Learning::Material::Question.where(op_lession_id: lesson.id)
      students = User::OpenEducat::OpTeachersService.new.teacher_class_detail batch, session
    end

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/give_homework', locals: { result: result, homeworks: homeworks, students: students}}
    end
  end

  def assign_homework
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    user_ids = User::Account::User.where(student_id: params[:student_ids]).pluck(:id).uniq.compact!
    if session.blank?
      render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau' }
    else
      batch_id = session.batch_id
      user_ids.each do |user_id|
        Learning::Homework::QuestionService.new.assign_homework user_id, params[:question_ids], batch_id
      end

      render json: { type: 'success', message: 'Giao bài tập về nhà thành công' }
    end
  end

  def teacher_evaluate
    result = User::OpenEducat::OpTeachersService.teacher_evaluate params, @teacher

    render json: result
  rescue StandardError => e
    redirect_error_site(e)
  end

  private

  def find_teacher
    @teacher = current_user.op_faculty
    return if @teacher.blank?
  end

  def validate_attendance student_id, session_id
    Learning::Batch::OpAttendanceLine.where(student_id: student_id, session_id: session_id).first.present?
  end
end
