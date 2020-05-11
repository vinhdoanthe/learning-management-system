class SocialCommunity::Feed::RewardService
  def reward_student params, user
    errors = ''
    ActiveRecord::Base.transaction do
      params[:students].each do |student|
        reward = Learning::Batch::SessionStudentReward.new
        reward.session_id = params[:session_id]
        reward.rewarded_by = user.id
        user = User::Account::User.where(student_id: student).first
        next if user.blank?
        reward.rewarded_to = user.id    
        reward.reward_type_id = params[:reward_type]

        post = SocialCommunity::Feed::RewardPost.create(posted_by:  user.id)
        reward.sc_post_id = post.id 

        reward.save

        # add transaction point, star, notification
        create_point_star
        create_noti
      end
    end

    errors
  rescue StandardError => e
    puts e
    'Đã có lỗi xảy ra! Thử lại sau!'
  end

  def create_noti
    true
  end

  def create_point_star
    true
  end
end

