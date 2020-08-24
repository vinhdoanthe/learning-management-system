class Learning::Batch::SessionStudentRewardsService
  def reward_student params, user 
    errors = []
    ActiveRecord::Base.transaction do
      params[:students].each do |student|
        student_user = User::Account::User.where(student_id: student).first
        next if student_user.blank?

        reward_type = Common::RewardType.where(id: params[:reward_type]).first
        if reward_type.blank?
          errors <<  { type: 'danger', message: "Đã có lỗi xảy ra khi thưởng cho học sinh #{ student_user.full_name }! Vui lòng thử lại sau!"}
          next
        end

        if check_exist_reward params[:session_id], student_user.id, params[:reward_type]
          errors << { type: 'danger', message: "Học sinh #{ student_user.full_name } đã được thưởng vì #{ reward_type.description }! Không thể khen thưởng lại!"}
          next
        end

        reward = Learning::Batch::SessionStudentReward.new
        reward.session_id = params[:session_id]
        reward.rewarded_by = user.id

        reward.rewarded_to = student_user.id
        reward.reward_type_id = params[:reward_type]
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        post = SocialCommunity::Feed::RewardPost.create(posted_by:  user.id, batch_id: session.batch_id)
        reward.sc_post_id = post.id
        reward.save

        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [ student_user.id ]
        post.create_notifications

        User::Reward::CoinStarsService.new.reward_coin_star reward, student_user.id, user.id
        errors << { type: 'success', message: "Khen thưởng học sinh #{ student_user.full_name } vì #{ reward_type.description } thành công !"}
      end
    end

    errors
  rescue StandardError => e    
    puts e
    'Đã có lỗi xảy ra! Thử lại sau!'
  end

  def check_exist_reward session_id, student_id, reward_type_id
    Learning::Batch::SessionStudentReward.where(session_id: session_id, reward_type_id: reward_type_id, rewarded_to: student_id).first.present?
  end
end
