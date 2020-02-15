module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info
    before_action :find_teacher
    skip_before_action :verify_authenticity_token, only: :teacher_class

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
        @batches.each{|b| data << {code: b.code, name: b.name, start_date: b.start_date, end_date: b.end_date, status: b.check_status}}
        render json: {data: data}, status: 200
      end
    end

    def teacher_class_detail
      @batch = Learning::Batch::OpBatch.find(params[:batch_id])
      @sessions = @batch.op_sessions.order(start_datetime: 'ASC')
      @session = @sessions.where('start_datetime >= ?', Time.now).first
      @session_index = @sessions.index(@session)
      @subject = @session.op_subject

      if request.method == 'POST'
        render json: {batch: @batch, session: @session, session_index: @session_index}
      end
    end

    def teaching_schedule
      @session = @teacher.op_sessions
    end

    private
    def find_teacher
      @teacher = current_user.op_faculty
    end
  end

end
