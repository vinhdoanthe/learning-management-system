class Learning::Batch::SessionStudentRewardsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def reward_student
    params[:students].each do |student|
      reward = Learning::Batch::SessionStudentReward.new
      reward.session_id = params[:session_id]
      reward.rewarded_by = current_user.id
      user = User::Account::User.where(student_id: student).first
      next if user.blank?
      reward.rewarded_to = user.id
      reward.reward_type_id = params[:reward_type]
      reward.save
    end

    render json: { type: 'success', message: 'Khen thưởng thành công!' } 
  rescue StandardError => e
    puts e
    render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau' }
  end
end
