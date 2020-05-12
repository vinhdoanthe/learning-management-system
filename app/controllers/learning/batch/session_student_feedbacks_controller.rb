class Learning::Batch::SessionStudentFeedbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def student_feedback
    result = Learning::Batch::SessionStudentFeedbacksService.new.create_new_feedback params, current_user
    
    render json: result
  end
end
