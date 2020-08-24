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

      def teacher_company_names teacher
        company_ids = teacher.op_sessions.pluck(:company_id).uniq
        Common::ResCompany.where(id: company_ids).pluck(:name)
      end
    end
  end
end
