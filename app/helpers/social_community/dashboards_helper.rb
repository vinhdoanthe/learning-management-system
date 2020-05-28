module SocialCommunity::DashboardsHelper

  def get_feed_content noti
    post = SocialCommunity::Feed::Post.where(id: noti.notifiable_id).first
    if post.blank?
      return (blank_post_noti_content noti)
    end
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
   # session_id = session_student_reward.session_id
   # session = Learning::Batch::OpSession.where(id: session_id).first
   # course_name = Learning::Course::OpCourse.where(id: session.course_id).first.name if session.present?
    batch = Learning::Batch::OpBatch.where(id: feed.post.batch_id).first
    course = Learning::Course::OpCourse.where(id: batch.course_id).first
    course_name = course.name if course.present?

    if !feed.created_user.nil? && course_name.present? && session_student_reward.reward_type.present?
      message = "Bạn vừa được giảng viên <span class='noti_teacher_name'> #{feed.created_user.faculty_name}</span> khen thưởng vì #{session_student_reward.reward_type.description} trong lớp <span class='noti_course_name'>#{ course_name }</span>"
    else
      message = "Bạn vừa được giảng viên khen thưởng"
    end
    [message, session_student_reward]
  end

  def photo_feed feed
    photos = feed.post.photos
    course_name = ''
    if photos.present?
#      photo = photos.first
#      course_name = Learning::Course::OpCourse.where(id: session.course_id).first.name if session.present?
      batch = Learning::Batch::OpBatch.where(id: feed.post.batch_id).first
      course_name = batch.op_course.name
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

  def blank_post_noti_content noti
    if noti.notifiable_type == "SocialCommunity::Feed::PhotoPost"
      "Giáo viên vừa đăng ảnh trong lớp học của con"
    else
      ''
    end
  end

end
