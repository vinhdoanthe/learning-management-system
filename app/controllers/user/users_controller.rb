module User
  class UsersController < ApplicationController

    before_action :authenticate_student!, only: [:my_class, :batch_detail]

    def information

    end

    def batch_detail
      @batch = Learning::Batch::OpBatch.find(params[:batch_id])
    end

    def my_class
      @batches = current_user.op_student.op_batches
    end

    # TODO: return general information of a student
    def general_information

      render :json => {}
    end


    # TODO: return parent information of a student
    def parent_information

      render :json => {}
    end
  end
end
