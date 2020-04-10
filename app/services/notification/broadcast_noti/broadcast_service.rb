class Notification::BroadcastNoti::BroadcastService
  def read_notice user_id, notice_id
    return if Notification::BroadcastNotiState.where(user_id: user_id, broadcast_notice_id: notice_id).first.present?

    read_noti = Notification::BroadcastNotiState.new
    read_noti.user_id = user_id
    read_noti.broadcast_notice_id = notice_id
    read_noti.read_at = Time.now
    read_noti.save
  end
end
