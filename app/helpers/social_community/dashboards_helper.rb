module SocialCommunity::DashboardsHelper

  def get_feed_content noti
    post = SocialCommunity::Feed::Post.where(id: noti.notifiable_id).first
    feeds = SocialCommunity::Feed::PostsService.decor_post_to_feed [post] 
    feed = feeds[0]
    
    case post.type
    when 'SocialCommunity::Feed::RewardPost'
     content = reward_feed feed
    when 'SocialCommunity::Feed::PhotoPost'
     content = photo_feed feed
    end

    content[0]
  end

  def reward_feed feed
    # find reward
    # render message
    course_name = ''
    session_student_reward = feed.post.session_student_reward
    session_id = session_student_reward.session_id
    session = Learning::Batch::OpSession.where(id: session_id).first
    course_name = Learning::Course::OpCourse.where(id: session.course_id).first.name if session.present?

    if !feed.created_user.nil? && course_name.present? && session_student_reward.reward_type.present?
      message = "Bạn vừa được giảng viên <span class='noti_teacher_name'> #{feed.created_user.faculty_name}</span> khen thưởng vì #{session_student_reward.reward_type.description} trong lớp <span class='noti_course_name'>#{ course_name }</span>"
    else
      message = "Bạn vừa được giảng viên khen thưởng"
    end
    [message, session_student_reward]
  end

  def photo_feed feed
    photos = feed.post.photos
    session = ''
    course_name = ''
    if photos.present?
      photo = photos.first
      session = Learning::Batch::OpSession.where(id: photo.session_id).first if photo.present?
      course_name = Learning::Course::OpCourse.where(id: session.course_id).first.name if session.present?
    end

    if feed.created_user.nil? && course_name.present?
      message = 'Giảng viên vừa đăng ảnh mới vào lớp học của bạn'
    else
      message = "Giảng viên <span class='noti_teacher_name'>#{feed.created_user.faculty_name}</span> vừa đăng ảnh vào lớp học <span class='noti_course_name'>#{ course_name }</span>"
    end 
    [message, photos]
    # find photos
    # render message
  end

end
