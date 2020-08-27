namespace :refer_friend do
  desc 'Cancel expired refer friend request'
  task cancel_expired_refer_request: :environment do
    expired_after_hours = Settings.refer_friend.request[:expired_after_hours].to_i
    expired_time = Time.now - expired_after_hours.hours
    expired_refer = SocialCommunity::ReferFriend.where('created_at < ? and state == ?', expired_time, ReferFriendConstants::REFER_FRIEND_STATE_WAITING)
    expired_refer.update_all(state: REFER_FRIEND_STATE_FAILED, note: "Hệ thống huỷ do quá hạn confirm")
  end

  desc 'Cancel lost lead refer friend request'
  task :cancel_lost_refer_request, [:days] =>  :environment do |t, args|
    days = args[:days].to_i
    time = Time.now = days.days
    lost_refer = SocialCommunity::ReferFriend.where('created_at > ?', time).joins(:crm_lead).where(crm_lead: { active: false })
    lost_refer.update_all(state: REFER_FRIEND_STATE_FAILED, note: "Huỷ do lead lost")
  end
end
