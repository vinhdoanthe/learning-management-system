module User
  module OpenEducat
    module OpTeachersHelper
      # Lấy số thông báo của Giáo viên
      def count_notification_teacher user
        # all_noti = Notification::BroadcastNoti.where('expiry_date >= ? ', Time.now).count
        all_noti = Notification::BroadcastNoti.count
        read_noti = Notification::BroadcastNotiState.where(user_id: current_user.id).count
        return all_noti - read_noti 
      end

    end
  end
end
