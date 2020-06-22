module SocialCommunity::DashboardsHelper

  def reward_feed feed
    message = SocialCommunity::Feed::FeedDecorator.new(feed).post_content
    session_student_reward = feed.post.session_student_reward
    
    [message, session_student_reward]
  end

  def photo_feed feed
    message = SocialCommunity::Feed::FeedDecorator.new(feed).post_content
    photos = feed.post.photos

    [message, photos]
  end

  def student_project_feed feed
    message = SocialCommunity::Feed::FeedDecorator.new(feed).post_content
    project = SocialCommunity::ScStudentProject.where(sc_post_id: feed.post.id).first

    [message, project]
  end

  def redeem_feed feed
    message = SocialCommunity::Feed::FeedDecorator.new(feed).post_content
    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: feed.post.id).first
    transaction = post_activity.activitiable
    product = transaction.redeem_product
    

    [message, product]
  end

  def blank_post_noti_content noti
    if noti.notifiable_type == "SocialCommunity::Feed::PhotoPost"
      "Giáo viên vừa đăng ảnh trong lớp học của con"
    else
      ''
    end
  end

end
