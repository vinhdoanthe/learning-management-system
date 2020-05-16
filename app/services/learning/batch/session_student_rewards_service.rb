class Learning::Batch::SessionStudentRewardsService
  def reward_student params, user 
    errors = ''
    ActiveRecord::Base.transaction do
      params[:students].each do |student|
        reward = Learning::Batch::SessionStudentReward.new
        reward.session_id = params[:session_id]
        reward.rewarded_by = user.id    
        student = User::Account::User.where(student_id: student).first
        next if user.blank?
        reward.rewarded_to = student.id    
        reward.reward_type_id = params[:reward_type]

        post = SocialCommunity::Feed::RewardPost.create(posted_by:  user.id)
        reward.sc_post_id = post.id     
        reward.save

        # add transaction point, star, notification
        User::Reward::CoinStarsService.new.create_coin_star

        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [user.id, student.id] 
        # SocialCommunity::Feed::RewardPostsService.new.create_noti
        post.create_notifications
      end
    end

    errors
  rescue StandardError => e    
    puts e
    'Đã có lỗi xảy ra! Thử lại sau!'
  end
end
