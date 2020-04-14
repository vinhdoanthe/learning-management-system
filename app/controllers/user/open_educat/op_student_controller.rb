class User::OpenEducat::OpStudentController < ApplicationController

    def batch_detail
      if params[:batch_id].present?
        @batch = Learning::Batch::OpBatch.find(params[:batch_id])
      end
    end

    def batches
      op_student = current_user.op_student
      if !op_student.nil?
        @batches = current_user.op_student.op_batches
      else
        @batches = []
      end

    rescue StandardError => e
      redirect_error_site(e)
    end

end
