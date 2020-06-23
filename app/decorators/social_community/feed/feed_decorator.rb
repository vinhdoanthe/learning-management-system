class SocialCommunity::Feed::FeedDecorator < SimpleDelegator
  include PostConstants::PostType

  # feed
  # - post
  # - created_user
  def post_content
    if !post.nil?
      if post.type == SC_QA_THREAD

      elsif post.type == SC_PT_POST
        photo_post_content
      elsif post.type == SC_RW_POST
        reward_post_content
      elsif post.type == SC_ST_PROJECT_POST
        st_project_post_content
      elsif post.type == SC_REDEEM_POST
        redeem_product_post_content
      elsif post.type == SC_REFER_FRIEND_POST
        refer_friend_post_content
      else
      end 
    else
    end
  end

  def qa_post_content
    ''
  end

  def photo_post_content
    photos = post.photos
    batch_code = ''
    course_name = ''
    if photos.present?
      batch = Learning::Batch::OpBatch.where(id: post.batch_id).first
      if !batch.nil?
        batch_code = batch.code
        course = batch.op_course
        course_name = course.nil? ? '' : course.name
      end
    end

    # TODO translation
    if created_user.nil? or batch_code.empty? or course_name.empty?
      message = 'Giảng viên đăng ảnh mới lớp học'
    else
      message = "Giảng viên <span class='noti_teacher_name'>#{created_user.faculty_name}</span> đăng ảnh lớp học <span class='noti_course_name'>#{ batch_code }</span> môn học <span class='noti_course_name'>#{ course_name }</span>"
    end 

    message
  end

  def reward_post_content
    batch_code = ''
    course_name = ''

    session_student_reward = post.session_student_reward
    rewarded_user = session_student_reward.nil? ? nil : session_student_reward.rewarded_user

    message = "<span class='noti_student_name'>#{rewarded_user.student_name}</span> được giảng viên khen thưởng"
    batch = Learning::Batch::OpBatch.where(id: post.batch_id).first
    if !batch.nil?
      batch_code = batch.code
      course = Learning::Course::OpCourse.where(id: batch.course_id).first
      course_name = course.name if !course.nil?
    end
    if !session_student_reward.nil?
      if !created_user.nil? and batch_code.present? and course_name.present? and session_student_reward.reward_type.present?
        message = "<span class='noti_student_name'>#{rewarded_user.student_name}</span> được giảng viên <span class='noti_teacher_name'> #{created_user.faculty_name}</span> khen thưởng vì #{session_student_reward.reward_type.description} trong lớp <span class='noti_course_name'>#{ batch_code }</span> môn học <span class='noti_course_name'>#{ course_name }</span>"
      end
    end

    message
  end

  def st_project_post_content
    project = SocialCommunity::ScStudentProject.where(sc_post_id: post.id).first
    message = "Giảng viên đăng sản phẩm cuối khoá lớp học"
    if project.present?
      batch = project.op_batch
      course = project.op_course
      student = project.op_student
      subject = project.op_subject

      if batch.present? and course.present? and subject.present? and student.present?
        message = "Học sinh <span class='noti_student_name'>#{ student.full_name }</span> hoàn thành dự án cuối khoá lớp <span class='noti_course_name'>#{ batch.code }</span> môn học <span class='noti_course_name'>#{ course.name }</span> Level #{ subject.level }"
      end
    end

    message
  end

  def redeem_product_post_content
    post_activity = SocialCommunity::Feed::PostActivity.where(sc_post_id: post.id).first
    message = "<span class='noti_student_name'>#{ created_user.student_name }</span> đổi quà thành công"
    transaction = post_activity.activitiable
    product = transaction.redeem_product

    if product.present?
      if transaction.status == 2
        message = "<span class='noti_student_name'>#{ created_user.student_name }</span> đổi quà #{ product.name } thành công"
      end
    end

    message
  end

  def refer_friend_post_content
    ''
  end
end
