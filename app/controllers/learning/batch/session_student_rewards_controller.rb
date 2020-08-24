class Learning::Batch::SessionStudentRewardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reward_student
    result = Learning::Batch::SessionStudentRewardsService.new.reward_student params, current_user

    if result.blank?
      render json: { type: 'success', message: 'Khen thưởng thành công!' }
    else
      render json: { type: 'danger', message: result }
    end
  end
end
