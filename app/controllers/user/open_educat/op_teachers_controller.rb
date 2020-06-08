class User::OpenEducat::OpTeachersController < ApplicationController
  before_action :find_teacher
  skip_before_action :verify_authenticity_token
  
  def teacher_class_detail
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
    unless params[:student].blank?
      params[:student].each_value do |student_params|
        line = {}
        student_id = User::OpenEducat::OpStudent.where(code: params['student_id']).first.id
        line[:student_id] = student_id
        line[:is_present] = ActiveModel::Type::Boolean.new.cast(student_params['check'])
        line[:note] = student_params['note'].to_s
        lines.append line
      end
    end

    errors = Api::Odoo.attendance(session_id: params[:session_id].to_i, faculty_id: @teacher.id, attendance_time: Time.now, attendance_lines: lines, lession_id: params[:lesson_id].to_i)
    
    if errors[0]
      unless params[:student].blank?
        params[:student].each_value do |student_params|
          User::Reward::CoinStarsService.new.reward_coin_star 'ATTENDANCE', student_id, 'coin', 0
          User::Reward::CoinStarsService.new.reward_coin_star 'ATTENDANCE', student_id, 'star', 0
        end
      end
      render json: {type: 'success', message: 'Điểm danh thành công!'}
    else
      render json: {type: 'danger', message: errors[1]}
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
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    return false if session.blank?

    batch = session.op_batch
    lesson = session.op_lession
    homeworks = Learning::Material::Question.where(op_lession_id: lesson.id)
    students = User::OpTeachersService.new.teacher_class_detail batch, session

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/give_homework', locals: { homeworks: homeworks, students: students}}
    end
  end

  def assign_homework
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    if session.blank?
      render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau' }
    else
      batch_id = session.batch_id
      params[:student_ids].each do |student_id|
      Learning::Homework::QuestionService.new.assign_homework student_id, params[:question_ids], batch_id
      end

      render json: { type: 'success', message: 'Giao bài tập về nhà thành công' }
    end
  end

  private

  def find_teacher
    @teacher = current_user.op_faculty
    return if @teacher.blank?
  end
end
