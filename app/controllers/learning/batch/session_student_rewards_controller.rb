class Learning::Batch::SessionStudentRewardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reward_student
    result = Learning::Batch::SessionStudentRewardsService.new.reward_student params, current_user

    render json: result
  end
end
