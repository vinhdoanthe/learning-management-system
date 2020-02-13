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
        render json: {data: @batches}, status: 200
      end
    end

    def teacher_class_detail

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
