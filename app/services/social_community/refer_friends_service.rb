include ReferFriendConstants

class SocialCommunity::ReferFriendsService
  require "securerandom"

  def create_refer_friend email, mobile, parent_name, note, user_id
    refer_friend = SocialCommunity::ReferFriend.new

    # create refer_key, code, state
    refer_key = SecureRandom.uuid
    code = generate_refer_code 
    state = REFER_FRIEND_STATE_WAITING

    if refer_friend.update(email: email,
        mobile: mobile,
        parent_name: parent_name,
        note: note,
        refer_key: refer_key,
        code: code,
        state: state,
        refer_by: user_id)

      # create noti
        refer_friend.create_notifications
      # build refer_friend_confirm_data
      email_data = build_confirm_data refer_friend

      SendGridMailer.new.send_email(EmailConstants::MailType::SEND_REFER_FRIEND_CONFIRM_EMAIL, email_data)

      # TODO: send Zalo notification

      return {
        noti: { type: 'success', message: 'Gửi lời mời thành công' },
        key: refer_friend
      }
    else
      return {
        noti: { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' },
        key: ''
      }
    end
  end

  def confirm_refer_friend refer_key
    # find refer_friend record
    # create notification
    refer_friend = SocialCommunity::ReferFriend.where(refer_key: refer_key).last

    return {
      success: false,
      refer_friend: nil
    } if refer_friend.nil?

    # check condition
    permission = can_confirm? refer_friend

    if permission[:success]
      # create crm_lead
      lead_object = build_lead_object refer_friend
      crm_lead = Api::Odoo.create_lead lead_object

      if crm_lead[:success]
        # update refer_friend
        if refer_friend.update(:state => REFER_FRIEND_STATE_CONFIRM,
            :crm_lead_id => crm_lead[:crm_lead_id])
          # TODO: send email
          # TODO: send Zalo notification
          refer_friend.create_notifications
          return {
            success: true,
            refer_friend: refer_friend
          } 
        else
          # TODO: delete crm_lead
          # return success = false
        end
      end

      return {
        success: false,
        message: 'đã có lỗi xảy ra',
        refer_friend: refer_friend
      }
    else
      return {
        success: false,
        message: permission[:message],
        refer_friend: refer_friend
      }
    end 
  end

  def discard_refer_friend refer_key
    # find refer_friend record
    refer_friend = SocialCommunity::ReferFriend.where(refer_key: refer_key).last

    return {
      success: false,
      message: 'lời giới thiệu không tồn tại hoặc đã bị xoá',
      refer_friend: nil
    } if refer_friend.nil?

    # check condition can discard?
    permission = can_discard? refer_friend
    if permission[:success]
      if refer_friend.update(:state => REFER_FRIEND_STATE_FAILED)
        # TODO: send email
        # TODO: create notification
        # TODO: send Zalo notification
        return {
          success: true,
          refer_friend: refer_friend
        }
      end
    end

    return {
      success: false,
      message: permission[:message],
      refer_friend: refer_friend
    }
  end

  def request_refer_odoo request

  end

  def create_refer_post refer
    post = SocialCommunity::Feed::ReferFriendPost.create(posted_by: refer.refer_by)
    refer_post = SocialCommunity::Feed::PostActivity.new
    refer_post.sc_post_id = post.id
    refer_post.activitiable = refer
    refer_post.save
    post
  end

  def generate_refer_code
    (0..5).map { (65 + rand(26)).chr }.join
  end

  def self.get_subscribed_users user_id
    [User::Account::User.where(id: user_id).first]
  end

  def cancel_refer_request refer_request, reason
    if refer_request.update(state: REFER_FRIEND_STATE_FAILED, note: reason)
      result = {
        noti: { type: 'success', message: 'Huỷ lời mời thành công' },
        key: refer_request
      }
    else
      result = {
        noti: {type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' },
        key: ''
      }
    end

    result
  end

  def can_cancel? refer_key, user, reason
    refer_friend = SocialCommunity::ReferFriend.where(refer_key: refer_key).last

    if refer_friend.blank?
      return {
        success: false,
        noti: {type: 'danger', message: 'Lời mời không tồn tại hoặc đã bị xoá! Vui lòng kiểm tra lại!' },
        key: ''
      }
    end

    result = {}

    unless refer_friend.is_waiting?
      return {
        success: false,
        noti: {type: 'danger', message: 'Chỉ có thể huỷ lời mời ở trạng thái đã gửi' },
        key: ''
      }
    end

    if user.is_admin? || user.id == refer_friend.refer_by
      if reason.blank? && user.is_admin?
        return {
          success: false,
          noti: {type: 'danger', message: 'Không thể huỷ yêu cầu giới thiệu mà thiếu lý do' },
          key: ''
        }
      end

        result = {
          success: true,
          noti: {},
          key: refer_friend
        }
    else
      result = {
        success: false,
        noti: {type: 'danger', message: "Bạn không có quyền xoá lời mời này" },
        key: ''
      }
    end

    result
  end

  def get_list params
    refer_friends = SocialCommunity::ReferFriend.all
    
    if params[:state].present?
      refer_friends = refer_friends.where(:state => params[:state])
    end

    if params[:rf_date_start].present? && params[:rf_date_end].present?
      refer_friends = refer_friends.where('created_at > ? AND created_at < ?', params[:rf_date_start], params[:rf_date_end])
    end

    refer_friends = refer_friends.order(:updated_at => 'DESC')
      .page(params[:page])
  end


  def get_state_report
    SocialCommunity::ReferFriend.group(:state).count
  end

  private

  def build_confirm_data refer_friend
    {
      :parent_email => refer_friend.email,
      :parent_name => refer_friend.parent_name,
      :refer_person_name => User::Account::User.find(refer_friend.refer_by).op_student&.vattr_parent_full_name,
      :confirm_url => Rails.application.routes.url_helpers.social_community_refer_friends_confirm_url(refer_friend.refer_key),
      :discard_url => Rails.application.routes.url_helpers.social_community_refer_friends_discard_url(refer_friend.refer_key),
      :expired_after_hours => Settings.refer_friend.request[:expired_after_hours].to_i
    }
  end

  def can_confirm? refer_friend
    if !refer_friend.state_waiting?
      return {
        sucess: false,
        message: "lời mời đã được xử lý"
      }
    end

    expired_after_hours = Settings.refer_friend.request[:expired_after_hours].to_i
    # return false if refer_friend created too long
    if (Time.now - expired_after_hours.hours) > refer_friend.created_at
      return {
        success: false,
        message: "đã quá hạn xác nhận"
      }
    end

    return { success: true }
  end

  def can_discard? refer_friend
    if !refer_friend.state_waiting?
      return {
        success: false,
        message: "lời mời đã được xử lý"
      }
    end

    expired_after_hours = Settings.refer_friend.request[:expired_after_hours].to_i
    # return false if refer_friend created too long
    if (Time.now - expired_after_hours.hours) > refer_friend.created_at
      return {
        success: false,
        message: "đã quá hạn xác nhận"
      }
    end

    return { success: true }
  end

  def build_lead_object refer_friend
    {
      :name => refer_friend.parent_name,
      :contact_name => refer_friend.parent_name,
      :mobile => refer_friend.mobile,
      :phone => refer_friend.mobile,
      :email_cc => refer_friend.email,
      :description => "Nguoi gioi thieu: #{refer_friend.note}",
      :medium_id => 100,
      :source_id => 300
    }
  end

end
