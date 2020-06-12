class Notification::ActivityNotificationDecorator < SimpleDelegator
  include NotificationConstants::Type
  include NotificationConstants::Key

  def notification_content
    case notifiable_type
    when SC_QA_THREAD
      qa_thread_notification_content
    when SC_PT_POST
      sc_photo_post_notification_content
    when SC_RW_POST
      sc_reward_post_notification_content
    when SC_ST_PROJECT_POST
      sc_student_project_notification_content
    when SC_REDEEM_POST
      sc_redeem_product_notification_content
    end
  end

  def sc_redeem_product_notification_content
    post = SocialCommunity::Feed::RedeemPost.where(id: notifiable_id).first
    activity_post = SocialCommunity::Feed::PostActivity.where(sc_post_id: post.id).first
    transaction = activity_post.activitiable
    display_html = ''

    case key
    when SC_REDEEM_POST_CREATE
      created_user = User::Account::User.where(id: transaction.student_id).first
      created_str = created_user.present? ? created_user.student_name : ''
      action_str = I18n.t('notification.redeem_product_post.create')
      product = transaction.redeem_product
      target_str = product.present? ? product.name : ''
      display_html = "#{ created_str } #{ action_str } #{ target_str } #{ I18n.t('notification.redeem_product_post.success') }"
    end

    display_html
  end

  def qa_thread_notification_content
    thread = SocialCommunity::QuestionAnswer::Thread.where(id: notifiable_id).first
    return '' if thread.nil?

    display_html = ''
    case key
    when SC_QA_THREAD_CREATE
      begin
        created_user = User::Account::User.where(id: thread.created_by).first
        created_str = (created_user.nil? ? '' : created_user.student_name)
        action_str = I18n.t('notification.qa_thread.create')
        lesson = Learning::Course::OpLession.where(id: thread.lesson_id).first
        target_str = (lesson.nil? ? '' : lesson.name)
        display_html = "#{created_str} #{action_str} #{target_str}"
      end
    when SC_QA_THREAD_REPLY
      begin
      end
    end

    display_html
  end

  def sc_photo_post_notification_content
    pt_post = SocialCommunity::Feed::PhotoPost.where(id:notifiable_id).first
    return '' if pt_post.nil?

    display_html = ''
    case key
    when SC_PT_POST_CREATE 
      begin
        created_user = pt_post.posted_user
        created_str = (created_user.nil? ? '' : created_user.faculty_name)

        action_str = I18n.t('notification.pt_post.create')

        course_name = ''
        batch = Learning::Batch::OpBatch.where(id: pt_post.batch_id).first
        unless batch.nil?
          course = batch.op_course
          unless course.nil?
            course_name = course.name
          end
        end
        target_str = course_name

        display_html = "#{created_str} #{action_str} #{target_str}"
      end
    when SC_PT_POST_COMMENT
      begin
      end
    end

    display_html
  end

  def sc_reward_post_notification_content
    rw_post = SocialCommunity::Feed::RewardPost.where(id: notifiable_id).first
    return '' if rw_post.nil?

    display_html = ''
    case key
    when SC_RW_POST_CREATE
      begin
        created_user = rw_post.posted_user
        created_str = (created_user.nil? ? '' : created_user.faculty_name)

        action_str = I18n.t('notification.rw_post.create')

        course_name = ''
        batch = Learning::Batch::OpBatch.where(id: rw_post.batch_id).first
        unless batch.nil?
          course = batch.op_course
          unless course.nil?
            course_name = course.name
          end
        end
        target_str = course_name

        display_html = "#{created_str} #{action_str} #{target_str}"
      end
    when SC_RW_POST_COMMENT
      begin
      end
    end

    display_html
  end

  def sc_student_project_notification_content
    st_project_post = SocialCommunity::Feed::StudentProjectPost.where(id: notifiable_id).first
    return '' if st_project_post.nil?

    display_html = ''
    case key
    when SC_ST_PROJECT_POST_CREATE
      begin
        project = SocialCommunity::ScStudentProject.where(sc_post_id: st_project_post.id).first
        unless project.nil?
          course = project.op_course
          course_name = (course.nil? ? '' : course.name)
          student = project.op_student
          student_name = (student.nil? ? '' : student.full_name)
          subject = project.op_subject
          subject_level = (subject.nil? ? '' : subject.level)

          display_html = "#{student_name} #{I18n.t('notification.st_project_post.create')} #{course_name} #{subject_level}"
        end
      end
    when SC_ST_PROJECT_POST_COMMENT
      begin
      end
    end

    display_html
  end
end
