class Notification::BroadcastNotiState < ApplicationRecord
	self.table_name = "broadcast_noti_state"

  belongs_to :user, class_name: "User::User", foreign_key: 'user_id'
  belongs_to :broadcast_noti, class_name: 'Notification::BroadcastNoti', foreign_key: 'broadcast_notice_id'
end
