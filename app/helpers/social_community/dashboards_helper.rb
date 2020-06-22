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
    when 'SocialCommunity::Feed::StudentProjectPost'
      content = student_project_feed feed
    end

    content[0]
  end

  def reward_feed feed
    # find reward
    # render message
    course_name = ''
    session_student_reward = feed.post.session_student_reward
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
    # find photos
    # render message
    photos = feed.post.photos
    course_name = ''
    if photos.present?
      batch = Learning::Batch::OpBatch.where(id: feed.post.batch_id).first
      course_name = batch.op_course.name
    end

    if feed.created_user.nil? && course_name.present?
      message = 'Giảng viên vừa đăng ảnh mới vào lớp học của bạn'
    else
      message = "Giảng viên <span class='noti_teacher_name'>#{feed.created_user.faculty_name}</span> vừa đăng ảnh vào lớp học <span class='noti_course_name'>#{ course_name }</span>"
    end 
    [message, photos]
  end

  def student_project_feed feed
    project = SocialCommunity::ScStudentProject.where(sc_post_id: feed.post.id).first
    message = "Giảng viên vừa đăng sản phẩm cuối khoá trong lớp học của bạn"
    if project.present?
      course = project.op_course
      student = project.op_student
      subject = project.op_subject

      if course.present? && student.present?
        message = "Học sinh <span class='noti_student_name'>#{ student.full_name }</span> vừa hoàn thành dự án cuối khoá lớp <span class='noti_course_name'>#{ course.name }</span> level #{ subject.level }"
      end
    end

    [message, project]
  end

  def redeem_feed feed
    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: feed.post.id).first
    message = "#{ feed.created_user.student_name } vừa đổi quà thành công"
    transaction = post_activity.activitiable
    product = transaction.redeem_product
    
    if product.present?
      if transaction.status == 2
      message = "#{ feed.created_user.student_name } vừa đổi quà #{ product.name } thành công"
      end
    end

    [message, product]
  end

  def refer_friend_feed feed
    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: feed.post.id).first
    refer = post_activity.activitiable

    message = "#{ feed.created_user.student_name } đã giới thiệu thành công bạn #{ refer.student_name }"

    [message, refer]
  end

  def blank_post_noti_content noti
    if noti.notifiable_type == "SocialCommunity::Feed::PhotoPost"
      "Giáo viên vừa đăng ảnh trong lớp học của con"
    else
      ''
    end
  end

end
