module SocialCommunity::DashboardsHelper
  def reward_feed feed
    # find reward
    # render message
    session_student_reward = feed.post.session_student_reward
    if !feed.created_user.nil?
      message = "Bạn vừa được giảng viên #{feed.created_user.faculty_name} khen thưởng vì #{session_student_reward.reward_type.description}"
    else
      message = "Bạn vừa được giảng viên khen thưởng"
    end
    [message, session_student_reward]
  end

  def photo_feed feed
    photos = feed.photos
    message = ''
    # find photos
    # render message
  end
end
