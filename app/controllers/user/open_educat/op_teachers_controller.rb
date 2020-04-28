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
      @thumbnail = @active_lesson.thumbnail.service_url
    else
      @thumbnail = ActionController::Base.helpers.asset_path('global/images/default-lesson-thumbnail.png')
    end

  end

  def teacher_checkin
    errors = Api::Odoo.checkin(session_id: params[:session_id], faculty_id: params[:faculty_id], check_in_time: params[:time])

    if errors.blank?
      error = {type: 'success', message: 'Checkin thành công'}
    else
      error = {type: 'danger', message: errors[0]}
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

        Learning::Homework::QuestionService.new.assign_homework student_id, params[:lesson_id], params[:session_id]
      end
    end

    errors = Api::Odoo.attendance(session_id: params[:session_id].to_i, faculty_id: @teacher.id, attendance_time: Time.now, attendance_lines: lines)
    if errors.blank?
      render json: {type: 'success', message: 'Điểm danh thành công!'}
    else
      render json: {type: 'danger', message: errors[0]}
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

  private

  def find_teacher
    @teacher = current_user.op_faculty
    return if @teacher.blank?
  end
end
