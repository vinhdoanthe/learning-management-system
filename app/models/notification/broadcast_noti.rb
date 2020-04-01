class Notification::BroadcastNoti < ApplicationRecord
	self.table_name = 'broadcast_noti'

  belongs_to :user, class_name: 'User::User', foreign_key: 'created_by'
end
