module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info

    def teacher_info

    end

    def teacher_class
      @teacher = current_user.op_faculty
      all_batchs ||= @teacher.op_batchs
      company_id = []
      all_batchs.each{ |b| company_id << b.company_id}
      @company = Common::ResCompany.where(:id => company_id)
      @batchs = OpTeachersService.filter_batch @teacher, params
    end
  end

end
