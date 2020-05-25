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
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        post = SocialCommunity::Feed::RewardPost.create(posted_by:  user.id, batch_id: session.batch_id)
        reward.sc_post_id = post.id     
        reward.save

        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [ student.id]
        # SocialCommunity::Feed::RewardPostsService.new.create_noti
        post.create_notifications

        # add transaction point, star, notification
        case reward.reward_type_id
        when 1
          key = 'REWARD_LVN'
        when 2
          key = 'REWARD_GB'
        when 3
          key = 'REWARD_TCPB'
        when 4
          key = 'REWARD_LBTL'
        end

        User::Reward::CoinStarsService.new.reward_coin_star key, student.id, 'coin', user.id
        User::Reward::CoinStarsService.new.reward_coin_star key, student.id, 'star', user.id
      end
    end

    errors
  rescue StandardError => e    
    puts e
    'Đã có lỗi xảy ra! Thử lại sau!'
  end
end
