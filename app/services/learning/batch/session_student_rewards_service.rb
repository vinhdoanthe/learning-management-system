class Learning::Batch::SessionStudentRewardsService
  def reward_student params, user 
    errors = ''
    ActiveRecord::Base.transaction do
      params[:students].each do |student|
        student = User::Account::User.where(student_id: student).first
        next if student.blank?

        if check_exist_reward params[:session_id], student.id, params[:reward_type]
          errors = 'Đã thưởng cho học sinh này rồi!'
          next
        end

        reward = Learning::Batch::SessionStudentReward.new
        reward.session_id = params[:session_id]
        reward.rewarded_by = user.id

        reward.rewarded_to = student.id
        reward.reward_type_id = params[:reward_type]
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        post = SocialCommunity::Feed::RewardPost.create(posted_by:  user.id, batch_id: session.batch_id)
        reward.sc_post_id = post.id
        reward.save

        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [ student.id]
        post.create_notifications

        User::Reward::CoinStarsService.new.reward_coin_star reward, student.id, user.id
        errors = ''
      end
    end

    errors
  rescue StandardError => e    
    puts e
    'Đã có lỗi xảy ra! Thử lại sau!'
  end

  def check_exist_reward session_id, student_id, reward_type_id
    Learning::Batch::SessionStudentReward.where(session_id: session_id, reward_type: reward_type_id, rewarded_to: student_id).first.present?
  end
end
