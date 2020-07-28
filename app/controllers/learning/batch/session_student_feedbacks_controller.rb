class Learning::Batch::SessionStudentFeedbacksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize!, :only => [:show]
  def student_feedback
    result = Learning::Batch::SessionStudentFeedbacksService.new.create_new_feedback params, current_user

    render json: result
  end

  def show

  end

  private
  def get_feedback
    if params[:id].present?
      @feedback = Learning::Batch::SessionStudentFeedback.where(id: params[:id].to_i).first
    else
      @feedback = nil
    end
  end

  def authorize!
    get_feedback
    if !Learning::Batch::SessionStudentFeedbacksService.can_authorize?(@feedback, current_user) 
      flash[:danger] = I18n.t('flash_notice.no_permissions')
      redirect_to root_path
    end
  end
end
