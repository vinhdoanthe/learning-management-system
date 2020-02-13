module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info
    skip_before_action :verify_authenticity_token, only: :teacher_class

    def teacher_info

    end

    def teacher_class
      @teacher = current_user.op_faculty
      all_batches ||= @teacher.op_batchs
      company_id = []
      all_batches.each{ |b| company_id << b.company_id}
      @company = Common::ResCompany.where(:id => company_id)
      @batches = OpTeachersService.filter_batch @teacher, params

      if request.method == 'POST'
        render json: {data: @batches}, status: 200
      end
    end
  end

end
