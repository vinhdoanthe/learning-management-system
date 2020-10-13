class Learning::Batch::OpSessionDecorator < SimpleDelegator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def display_session_time
    "<b>#{start_datetime.strftime('%H:%M')}</b> #{I18n.t('datetime.to')}  <b>#{end_datetime.strftime('%H:%M')}</b> | <b>#{I18n.t('date.day_names')[start_datetime.to_date.wday]}, #{start_datetime.day}/#{start_datetime.month}/#{start_datetime.year}</b>"     
  end

  def display_tooltip_session_timeline
    if start_datetime < Time.now
      "#{ I18n.t('teacher_class.pass_session')} <br> #{ start_datetime.strftime('%H:%M | %d/%m/%Y') }"
    else
      "#{ I18n.t('teacher_class.coming_session')} <br> #{ start_datetime.strftime('%H:%M | %d/%m/%Y') }"
    end
  end

  def display_checkin_button
    if (['confirm', 'draft'].include? state) && check_in_time.blank?
      if Time.now > (start_datetime - 15.minutes)
        "<button type='button' class='btn btn-default btn-embossed' id='teacher_checkin' data-toggle='modal' data-target='#modal_checkin' ><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button>"
      else
        "<div class='tooltip-span' data-toggle='tooltip' data-html='true' title='Chưa tới giờ Check-in'><button type='button' class='btn btn-default btn-embossed'  disabled><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button></div>"
      end
    else
      if check_in_state == 'none'
        if start_datetime > Time.now
          "<button type='button' class='btn btn-default btn-embossed'  disabled><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button>"
        elsif end_datetime < Time.now
          "<div class='tooltip-span' data-toggle='tooltip' data-html='true' title='Quên Check-in'><button type='button' class='btn btn-danger'  disabled><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button></div>"
        end
      elsif check_in_state == 'good'
        "<div class='tooltip-span' data-toggle='tooltip' data-html='true' title='Check-in đúng giờ'><button type='button' class='btn btn-success'  disabled><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button></div>"
      elsif check_in_state == 'late'
        "<div class='tooltip-span' data-toggle='tooltip' data-html='true' title='Check-in muộn'><button type='button' class='btn btn-warning' disabled><span>#{ image_tag(ActionController::Base.helpers.asset_path('hotel-2.png')) }</span>Check-in</button></div>"
      else
      end
    end
  end
end
