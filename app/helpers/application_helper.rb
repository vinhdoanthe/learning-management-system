module ApplicationHelper

  include User::SessionsHelper
  include Learning::Course::OpLessionHelper
  include Learning::Batch::OpBatchesHelper
  def get_week_day wday
    case wday
    when 'Monday'
      'Thứ 2'
    when 'Tuesday' 
      'Thứ 3'
    when 'Wednesday'
      'Thứ 4'
    when 'Thursday'
      'Thứ 5'
    when 'Friday'
      'Thứ 6'
    when 'Saturday'
      'Thứ 7'
    when 'Sunday'
      'Chủ nhật'
    end
  end

  def read_notice? user, notice
    state = Notification::BroadcastNotiState.where(user_id: user.id, broadcast_notice_id: notice.id)
    if state.present?
      return true
    else
      return false
    end
  end
end
