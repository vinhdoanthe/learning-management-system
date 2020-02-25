module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info
    before_action :find_teacher
    skip_before_action :verify_authenticity_token
    before_action :instance_session, only: [:active_session]

    def teacher_info

    end

    def teacher_class
      all_batches ||= @teacher.op_batches
      company_id = []
      all_batches.each {|b| company_id << b.company_id}
      @company = Common::ResCompany.where(:id => company_id)
      @batches = OpTeachersService.filter_batch @teacher, params

      if request.method == 'POST'
        data = []
        @batches.each do |b|
          data << {
              id: b.id || '',
              code: b.code || '',
              name: b.name || '',
              start_date: b.start_date,
              end_date: b.end_date,
              status: b.check_status,
              student_count: b.op_student_courses.count.to_s,
              progress: b.current_session_level
          }
        end
        render json: {data: data}, status: 200
      end
    end

    def teacher_class_detail
      @batch = Learning::Batch::OpBatch.find(params[:batch_id].to_i)
      @sessions = @batch.op_sessions.order(start_datetime: 'ASC')

      if params[:subject_id].present?
        @current_subject_id = params[:subject_id].to_i
        @sessions = @sessions.where(:subject_id => params[:subject_id].to_i)
      else
        current_subject = @sessions.where.not('state = ? OR state = ?', Learning::Constant::Batch::Session::STATE_DONE, Learning::Constant::Batch::Session::STATE_CANCEL).first
        current_subject = @sessions.last if current_subject.blank?
        @current_subject_id = current_subject.subject_id
        @sessions = @sessions.where(subject_id: @current_subject_id)
      end

      if params[:session_index].present?
        @session = @sessions[params[:session_index].to_i]
      else
        @session = @sessions.where('start_datetime >= ?', Time.now).first
      end
      @session = @sessions.last if @session.blank?
      @session_index = @sessions.index(@session)
      @subject = @session.op_subject
      sessions_time = @sessions.pluck(:start_datetime, :end_datetime)
      @lesson = @session.op_lession
      if @lesson && @lesson.thumbnail.attached?
        img_src = @lesson.thumbnail.service_url
      else
        img_src = ActionController::Base.helpers.asset_path('default_lesson_thumbnail.jpg')
      end

      all_students = OpTeachersService.new.teacher_class_detail @batch, @session

      teacher_class_detail_active_session(@session.id, @subject.id, @session_index, all_students)

      if request.method == 'POST'
        render json: {batch: @batch, session: @session, session_index: @session_index, subject: @subject, note: @note, students: all_students, sessions_time: sessions_time, lesson: {learning_device: 'this is learning device'}, img_src: img_src}
      end
    end

    def teaching_schedule
      @sessions = @teacher.op_sessions
      schedules = OpTeachersService.teaching_schedule(@sessions, params)
      if request.method == 'POST'
        render json: {schedules: schedules}
      end
    end

    def active_session
      render json: {session: @session, subject_level: @subject.level, session_index: @session_index, students: @student_list}
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
          line[:student_id] = (student_params['student_id']).to_i
          line[:is_present] = ActiveModel::Type::Boolean.new.cast(student_params['check'])
          line[:note] = student_params['note'].to_s
          lines.append line
        end
      end

      errors = Api::Odoo.attendance(session_id: params[:session_id].to_i, faculty_id: params[:faculty_id].to_i, attendance_time: Time.now, attendance_lines: lines)
    end

    private

    def instance_session
      @session = Learning::Batch::OpSession.find(session[:active_session_id])
      @subject = Learning::Course::OpSubject.find(session[:active_session_subject_id])
      @session_index = session[:active_session_index]
      @student_list = session[:student_list]
    end

    def find_teacher
      @teacher = current_user.op_faculty
    end
  end

end
