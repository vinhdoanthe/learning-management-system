module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info
    before_action :find_teacher
    skip_before_action :verify_authenticity_token, only: [:teacher_class, :teacher_class_detail, :teaching_schedule]

    def teacher_info

    end

    def teacher_class
      all_batches ||= @teacher.op_batches
      company_id = []
      all_batches.each{ |b| company_id << b.company_id}
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
                    student_count: b.op_student_courses.where(:state => 'on').count.to_s,
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
      
      @session = @sessions.last unless @session
      @session_index = @sessions.index(@session)
      @subject = @session.op_subject
      sessions_time = @sessions.pluck(:start_datetime, :end_datetime)

      all_students = OpTeachersService.new.teacher_class_detail @batch, @session

      if request.method == 'POST'
        render json: {batch: @batch, session: @session, session_index: @session_index, subject: @subject, note: @note, students: all_students, sessions_time: sessions_time}
      end
    end

    def teaching_schedule
      @sessions = @teacher.op_sessions
      schedules = OpTeachersService.teaching_schedule(@sessions, params)
      if request.method == 'POST'
        render json: { schedules: schedules}
      end
    end

    private
    def find_teacher
      @teacher = current_user.op_faculty
    end
  end

end
