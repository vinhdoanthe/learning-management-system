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

  def get_month month
    case month
    when '01'
      'THÁNG 1'
    when '02'
      'THÁNG 2'
    when '03'
      'THÁNG 3'
    when '04'
      'THÁNG 4'
    when '05'
      'THANG 5'
    when '06'
      'THÁNG 6'
    when '07'
      'THÁNG 7'
    when '08'
      'THÁNG 8'
    when '09'
      'THÁNG 9'
    when '10'
      'THÁNG 10'
    when '11'
      'THÁNG 11'
    when '12'
      'THÁNG 12'
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
